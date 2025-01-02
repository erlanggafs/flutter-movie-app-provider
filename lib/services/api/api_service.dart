import 'package:dio/dio.dart'; // Import Dio untuk melakukan HTTP request
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import flutter_dotenv untuk membaca file .env yang berisi konfigurasi

import '../../data/model/movie_model.dart'; // Import model Movie untuk memetakan data dari API

class ApiService {
  final Dio _dio = Dio(); // Membuat instance Dio untuk melakukan HTTP requests
  final String _baseUrl = dotenv.env['BASE_URL'] ?? '';
  final String _apiKey = dotenv.env['API_KEY'] ?? '';

  // Metode untuk mengambil data dari API berdasarkan endpoint dan halaman
  Future<List<Movie>> _fetchData(String endpoint, {required int page}) async {
    try {
      final response = await _dio.get('$_baseUrl$endpoint', queryParameters: {
        'api_key': _apiKey,
        'page': page.toString(),
      });

      // Jika status code respons 200 (OK), parsing data
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'];
        return data.map((movie) => Movie.fromMap(movie)).toList();
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      throw Exception('Failed to load movies: $e');
    }
  }

  // Metode untuk mengambil data film yang akan datang
  Future<List<Movie>> fetchUpcomingMovies({required int page}) {
    return _fetchData('/movie/upcoming', page: page);
  }

  // Metode untuk mengambil data film yang sedang tayang
  Future<List<Movie>> fetchNowPlayingMovies({required int page}) {
    return _fetchData('/movie/now_playing', page: page);
  }

  // Metode untuk mengambil data film populer
  Future<List<Movie>> fetchPopularMovies({required int page}) {
    return _fetchData('/movie/popular', page: page);
  }

  // Metode untuk mengambil data film dengan rating tertinggi
  Future<List<Movie>> fetchTopRatedMovies({required int page}) {
    return _fetchData('/movie/top_rated', page: page);
  }

  // Metode untuk mengambil data TV series yang sedang tayang
  Future<List<Movie>> fetchTvSeriesOnTheAir({required int page}) {
    return _fetchData('/tv/on_the_air', page: page);
  }

  // Metode untuk mengambil data TV series dengan rating tertinggi
  Future<List<Movie>> fetchTvTopRated({required int page}) {
    return _fetchData('/tv/top_rated', page: page);
  }
}
