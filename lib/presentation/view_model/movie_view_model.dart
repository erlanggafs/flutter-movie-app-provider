import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/data/model/movie_model.dart';
import 'package:flutter_movie_app/services/api/api_service.dart';
import 'package:logger/logger.dart';

import '../../data/local_datasource/database/app_database.dart';

class MovieViewModel with ChangeNotifier {
  final Logger _logger = Logger();

  // Private properties for movie lists
  List<Movie> _upcomingMovies = [];
  List<Movie> _nowPlayingMovies = [];
  List<Movie> _popularMovies = [];
  List<Movie> _topRatedMovies = [];
  List<Movie> _tvSeriesOnTheAir = [];
  List<Movie> _tvTopRated = [];
  List<Movie> _filteredMovies = [];
  List<Movie> _moviesIsSaved = [];
  List<Movie> _allMovies = [];

  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMoreData = true;

  // Getters for movie lists
  List<Movie> get upcomingMovies => _upcomingMovies;
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;
  List<Movie> get popularMovies => _popularMovies;
  List<Movie> get topRatedMovies => _topRatedMovies;
  List<Movie> get tvSeriesOnTheAir => _tvSeriesOnTheAir;
  List<Movie> get tvTopRated => _tvTopRated;
  List<Movie> get filteredMovies => _filteredMovies;
  List<Movie> get moviesIsSaved => _moviesIsSaved;
  List<Movie> get allMovies => _allMovies;

  // Loading states
  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;

  // Error handling
  String? _error;
  String? get error => _error;

  final ApiService _apiService = ApiService();

  Future<void> fetchUpcomingMovies() async {
    if (_isLoading || !_hasMoreData) {
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      final database =
          await $FloorAppDatabase.databaseBuilder('app_database.db').build();
      final movieDao = database.movieDao;

      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        _upcomingMovies = await movieDao.getMoviesByCategory('upcoming');
        _hasMoreData = false;
        return;
      }

      final moviesResponse = await _apiService.fetchUpcomingMovies(
        page: _currentPage,
      );

      if (moviesResponse.isNotEmpty) {
        await insertMoviesToDatabase(moviesResponse, category: 'upcoming');

        // Append new movies to existing list instead of replacing
        final allMovies = await movieDao.getMoviesByCategory('upcoming');
        _upcomingMovies = allMovies;
        _currentPage++;
      } else {
        _hasMoreData = false;
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //Method for Fetch data Now Playing
  Future<void> fetchNowPlayingMovies() async {
    if (_isLoading || !_hasMoreData) {
      return; // Cegah jika sedang loading atau tidak ada data lebih lanjut.
    }

    _isLoading = true; // Tandai bahwa proses loading sedang berlangsung.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners(); // Memperbarui UI.
    });

    _logger.i("Fetching Now Playing movies...");

    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final movieDao = database.movieDao;

    try {
      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        _logger.w("No internet connection. Fetching data from local DB");
        _nowPlayingMovies = await movieDao.getMoviesByCategory('nowplaying');
      } else {
        _logger.i("Internet connection available. Fetching data from API");

        // Ambil data dari API dengan pagination.
        final moviesResponse = await _apiService.fetchNowPlayingMovies(
          page: _currentPage, // Halaman saat ini.
          // Ukuran halaman.
        );

        if (moviesResponse.isNotEmpty) {
          _logger.i("Inserting movies to database");
          await insertMoviesToDatabase(moviesResponse, category: 'nowplaying');

          _nowPlayingMovies = await movieDao.getMoviesByCategory(
              'nowplaying'); // Sinkronkan dengan data lokal.
          _currentPage++; // Tingkatkan nilai halaman untuk request berikutnya.
        } else {
          _hasMoreData = false; // Tandai bahwa tidak ada data lebih lanjut.
        }
      }
    } catch (error) {
      _error = error.toString();
      _logger.e("Error occurred: $error");
    } finally {
      _nowPlayingMovies =
          await movieDao.getMoviesByCategory('nowplaying'); // Sinkronkan data.
      _isLoading = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners(); // Perbarui UI.
      });
    }
  }

  //Method Fetch data Top Rated
  Future<void> fetchTopRatedMovies() async {
    if (_isLoading || !_hasMoreData)
      return; // Cegah jika sedang loading atau tidak ada data lebih lanjut.

    _isLoading = true; // Tandai bahwa proses loading sedang berlangsung.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners(); // Memperbarui UI.
    });

    _logger.i("Fetching Top movies...");

    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final movieDao = database.movieDao;

    try {
      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        _logger.w("No internet connection. Fetching data from local DB");
        _topRatedMovies = await movieDao.getMoviesByCategory('topRatedMovies');
      } else {
        _logger.i("Internet connection available. Fetching data from API");

        // Ambil data dari API dengan pagination.
        final moviesResponse = await _apiService.fetchTopRatedMovies(
          page: _currentPage, // Halaman saat ini.
          // Ukuran halaman.
        );

        if (moviesResponse.isNotEmpty) {
          _logger.i("Inserting movies to database");
          await insertMoviesToDatabase(moviesResponse,
              category: 'topRatedMovies');

          _topRatedMovies = await movieDao.getMoviesByCategory(
              'topRatedMovies'); // Sinkronkan dengan data lokal.
          _currentPage++; // Tingkatkan nilai halaman untuk request berikutnya.
        } else {
          _hasMoreData = false; // Tandai bahwa tidak ada data lebih lanjut.
        }
      }
    } catch (error) {
      _error = error.toString();
      _logger.e("Error occurred: $error");
    } finally {
      _topRatedMovies = await movieDao
          .getMoviesByCategory('topRatedMovies'); // Sinkronkan data.
      _isLoading = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners(); // Perbarui UI.
      });
    }
  }

  //Method for Fetch data Popular Movies
  Future<void> fetchPopularMovies() async {
    if (_isLoading || !_hasMoreData)
      return; // Cegah jika sedang loading atau tidak ada data lebih lanjut.

    _isLoading = true; // Tandai bahwa proses loading sedang berlangsung.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners(); // Memperbarui UI.
    });

    _logger.i("Fetching Popular movies...");

    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final movieDao = database.movieDao;

    try {
      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        _logger.w("No internet connection. Fetching data from local DB");
        _popularMovies = await movieDao.getMoviesByCategory('popularMovie');
      } else {
        _logger.i("Internet connection available. Fetching data from API");

        // Ambil data dari API dengan pagination.
        final moviesResponse = await _apiService.fetchPopularMovies(
          page: _currentPage, // Halaman saat ini.
          // Ukuran halaman.
        );

        if (moviesResponse.isNotEmpty) {
          _logger.i("Inserting movies to database");
          await insertMoviesToDatabase(moviesResponse,
              category: 'popularMovie');
          _popularMovies = await movieDao.getMoviesByCategory(
              'popularMovie'); // Sinkronkan dengan data lokal.
          _currentPage++; // Tingkatkan nilai halaman untuk request berikutnya.
        } else {
          _hasMoreData = false; // Tandai bahwa tidak ada data lebih lanjut.
        }
      }
    } catch (error) {
      _error = error.toString();
      _logger.e("Error occurred: $error");
    } finally {
      _popularMovies = await movieDao
          .getMoviesByCategory('popularMovie'); // Sinkronkan data.
      _isLoading = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners(); // Perbarui UI.
      });
    }
  }

  //Method for Fetch data TV Series
  Future<void> fetchTvSeriesOnTheAir() async {
    if (_isLoading || !_hasMoreData)
      return; // Cegah jika sedang loading atau tidak ada data lebih lanjut.

    _isLoading = true; // Tandai bahwa proses loading sedang berlangsung.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners(); // Memperbarui UI.
    });

    _logger.i("Fetching TV Series...");

    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final movieDao = database.movieDao;

    try {
      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        _logger.w("No internet connection. Fetching data from local DB");
        _tvSeriesOnTheAir = await movieDao.getMoviesByCategory('tvSeries');
      } else {
        _logger.i("Internet connection available. Fetching data from API");

        // Ambil data dari API dengan pagination.
        final moviesResponse = await _apiService.fetchTvSeriesOnTheAir(
          page: _currentPage, // Halaman saat ini.
          // Ukuran halaman.
        );

        if (moviesResponse.isNotEmpty) {
          _logger.i("Inserting movies to database");
          await insertMoviesToDatabase(moviesResponse, category: 'tvSeries');

          _tvSeriesOnTheAir = await movieDao
              .getMoviesByCategory('tvSeries'); // Sinkronkan dengan data lokal.
          _currentPage++; // Tingkatkan nilai halaman untuk request berikutnya.
        } else {
          _hasMoreData = false; // Tandai bahwa tidak ada data lebih lanjut.
        }
      }
    } catch (error) {
      _error = error.toString();
      _logger.e("Error occurred: $error");
    } finally {
      _tvSeriesOnTheAir =
          await movieDao.getMoviesByCategory('tvSeries'); // Sinkronkan data.
      _isLoading = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners(); // Perbarui UI.
      });
    }
  }

  //Method for Fetch data Top Rated
  Future<void> fetchTvTopRated() async {
    if (_isLoading || !_hasMoreData)
      return; // Cegah jika sedang loading atau tidak ada data lebih lanjut.

    _isLoading = true; // Tandai bahwa proses loading sedang berlangsung.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners(); // Memperbarui UI.
    });

    _logger.i("Fetching Tv top rated...");

    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final movieDao = database.movieDao;

    try {
      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        _logger.w("No internet connection. Fetching data from local DB");
        _tvTopRated = await movieDao.getMoviesByCategory('tvTopRated');
      } else {
        _logger.i("Internet connection available. Fetching data from API");

        // Ambil data dari API dengan pagination.
        final moviesResponse = await _apiService.fetchTvTopRated(
          page: _currentPage, // Halaman saat ini.
          // Ukuran halaman.
        );

        if (moviesResponse.isNotEmpty) {
          _logger.i("Inserting movies to database");
          await insertMoviesToDatabase(moviesResponse, category: 'tvTopRated');

          _tvTopRated = await movieDao.getMoviesByCategory(
              'tvTopRated'); // Sinkronkan dengan data lokal.
          _currentPage++; // Tingkatkan nilai halaman untuk request berikutnya.
        } else {
          _hasMoreData = false; // Tandai bahwa tidak ada data lebih lanjut.
        }
      }
    } catch (error) {
      _error = error.toString();
      _logger.e("Error occurred: $error");
    } finally {
      _tvTopRated =
          await movieDao.getMoviesByCategory('tvTopRated'); // Sinkronkan data.
      _isLoading = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners(); // Perbarui UI.
      });
    }
  }

  //Untuk Input Data ke Local DAO
  Future<void> insertMoviesToDatabase(List<Movie> movies,
      {required String category}) async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final movieDao = database.movieDao;

    try {
      int insertedCount = 0;
      for (var movie in movies) {
        final updatedMovie = movie.copyWith(category: category);
        _logger.i('Inserting into the db: ${movie.title}');
        await movieDao.insertAllMovie(updatedMovie);
        insertedCount++;
      }
      _logger.i('Movies inserted successfully: $insertedCount movies added.');
    } catch (e) {
      _logger.e('Error inserting movies: $e');
    }
  }

  //Method for Update Database local
  Future<void> updateMovietoDB(Movie movie) async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final movieDao = database.movieDao;

    try {
      // Membuat salinan Movie yang diperbarui
      final updatedMovie = Movie(
        id: movie.id,
        title: movie.title,
        originalName: movie.originalName,
        backDropPath: movie.backDropPath,
        overview: movie.overview,
        popularity: movie.popularity,
        posterPath: movie.posterPath,
        originalLanguage: movie.originalLanguage,
        releaseDate: movie.releaseDate,
        firstAirDate: movie.firstAirDate,
        voteAverage: movie.voteAverage,
        voteCount: movie.voteCount,
        isSaved: !movie.isSaved, // Membalik status isLiked
        genreIds: movie.genreIds,
        category: movie.category,
      );

      // Memperbarui data di database
      await movieDao.updateMovie(updatedMovie);

      // Memperbarui data di list lokal
      final index = _moviesIsSaved.indexWhere((m) => m.id == movie.id);
      if (index != -1) {
        _upcomingMovies[index] = updatedMovie;
        notifyListeners();
      }
    } catch (e) {
      _logger.e('Error updating movie: $e');
    }
  }

  //Method Get All Data From Local DB
  Future<List<Movie>> getAllMovieFromDB() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final movieDao = database.movieDao;
    return await movieDao.getAllMovie();
  }

  //Method Get All data from Local DB By Category
  Future<List<Movie>> getMoviesFromDBByCategory(String category) async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final movieDao = database.movieDao;

    try {
      final movies = await movieDao.getMoviesByCategory(category);
      _logger.i(
          'Movies retrieved successfully for category "$category": ${movies.length} movies found.');
      return movies;
    } catch (e) {
      _logger.e('Error retrieving movies for category "$category": $e');
      return [];
    }
  }

  //Method for Fetch and Show data Is Saved on DB
  Future<void> getMovieIsSavedFromDB() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final movieDao = database.movieDao;
    _moviesIsSaved = await movieDao.getSavedMovie();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Movie? getMovieById(String id) {
    try {
      return _allMovies.firstWhere((movie) => movie.id.toString() == id);
    } catch (e) {
      return null; // Kembalikan null jika film tidak ditemukan
    }
  }

  Future<void> refreshSavedMovie() async {
    await getMovieIsSavedFromDB();
    notifyListeners(); // Pastikan Consumer di-update
  }

  // Method to fetch and display all movies from different categories
  // Fetch all movies
  Future<void> fetchAllMovies() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Fetch movies from different categories
      _upcomingMovies = await getMoviesFromDBByCategory('upcoming');
      _nowPlayingMovies = await getMoviesFromDBByCategory('nowplaying');
      _popularMovies = await getMoviesFromDBByCategory('popularMovie');
      _topRatedMovies = await getMoviesFromDBByCategory('topRatedMovies');
      _tvSeriesOnTheAir = await getMoviesFromDBByCategory('tvSeries');
      _tvTopRated = await getMoviesFromDBByCategory('tvTopRated');

      // Combine all movies
      _allMovies = [
        ..._upcomingMovies,
        ..._nowPlayingMovies,
        ..._popularMovies,
        ..._topRatedMovies,
        ..._tvSeriesOnTheAir,
        ..._tvTopRated
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Filter movies
  void filterMovies(String query) {
    if (query.isEmpty) {
      _filteredMovies = [];
    } else {
      _filteredMovies = _allMovies.where((movie) {
        final titleLower = movie.title.toLowerCase();
        final searchLower = query.toLowerCase();
        return titleLower.contains(searchLower);
      }).toList();
    }
    notifyListeners();
  }
}
