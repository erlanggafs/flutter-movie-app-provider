import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/presentation/view_model/movie_view_model.dart';
import 'package:flutter_movie_app/presentation/widget/carousel_slider_widget.dart';
import 'package:flutter_movie_app/presentation/widget/logout_confirm_dialog.dart';
import 'package:flutter_movie_app/presentation/widget/search_bar_widget.dart';
import 'package:flutter_movie_app/presentation/widget/section_button_widget.dart';
import 'package:flutter_movie_app/presentation/widget/square_list_widget.dart';
import 'package:flutter_movie_app/presentation/widget/vertical_list_widget.dart';
import 'package:flutter_movie_app/utils/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  bool isFirstLoad = true;
  bool _initialized = false;

  // Override to keep the state alive
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    if (!_initialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final movieProvider =
            Provider.of<MovieViewModel>(context, listen: false);
        if (movieProvider.allMovies.isEmpty) {
          _fetchMovies();
        } else {
          setState(() {
            isFirstLoad = false;
          });
        }
      });
      _initialized = true;
    }
  }

  Future<void> _fetchMovies() async {
    final movieProvider = Provider.of<MovieViewModel>(context, listen: false);

    // Check if data already exists before fetching
    if (movieProvider.upcomingMovies.isEmpty) {
      await movieProvider.fetchUpcomingMovies();
    }
    if (movieProvider.nowPlayingMovies.isEmpty) {
      await movieProvider.fetchNowPlayingMovies();
    }
    if (movieProvider.topRatedMovies.isEmpty) {
      await movieProvider.fetchTopRatedMovies();
    }
    if (movieProvider.popularMovies.isEmpty) {
      await movieProvider.fetchPopularMovies();
    }
    if (movieProvider.tvSeriesOnTheAir.isEmpty) {
      await movieProvider.fetchTvSeriesOnTheAir();
    }
    if (movieProvider.tvTopRated.isEmpty) {
      await movieProvider.fetchTvTopRated();
    }
    if (movieProvider.allMovies.isEmpty) {
      await movieProvider.fetchAllMovies();
    }

    if (mounted) {
      setState(() {
        isFirstLoad = false;
      });
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');

    context.go('/login');
  }

  Future<void> _showLogoutDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LogoutConfirmationDialog(onConfirm: _logout);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.iconTheme.color,
        automaticallyImplyLeading: false,
        title: Text(
          'Moview',
          style: GoogleFonts.pacifico(
            fontSize: 24,
            color: AppColors.primary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MovieSearchDelegate(
                  allMovies: context.read<MovieViewModel>().allMovies,
                  onQueryChanged: (query) {
                    context.read<MovieViewModel>().filterMovies(query);
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: theme.iconTheme.color,
            ),
            onPressed: _showLogoutDialog,
          ),
        ],
      ),
      body: Consumer<MovieViewModel>(
        builder: (context, movieProvider, child) {
          if (isFirstLoad && movieProvider.isLoading) {
            return Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: AppColors.primary,
                size: 50,
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionButtonWidget(
                    title: 'Up Coming >',
                    onPressed: () {
                      context.push('/home/viewmore',
                          extra: movieProvider.upcomingMovies);
                    },
                  ),
                  CarouselSliderWidget(movies: movieProvider.upcomingMovies),
                  SectionButtonWidget(
                    title: 'Now Playing >',
                    onPressed: () {
                      context.push('/home/viewmore',
                          extra: movieProvider.nowPlayingMovies);
                    },
                  ),
                  SquareListWidget(
                    movies: movieProvider.nowPlayingMovies,
                    width: 110,
                  ),
                  SectionButtonWidget(
                    title: 'Top Rates >',
                    onPressed: () {
                      context.push('/home/viewmore',
                          extra: movieProvider.topRatedMovies);
                    },
                  ),
                  SquareListWidget(
                    movies: movieProvider.topRatedMovies,
                    width: 190,
                  ),
                  SectionButtonWidget(
                    title: 'Popular For You >',
                    onPressed: () {
                      context.push('/home/viewmore',
                          extra: movieProvider.popularMovies);
                    },
                  ),
                  VerticalListWidget(
                    movies: movieProvider.popularMovies,
                  ),
                  SectionButtonWidget(
                    title: 'TV Series >',
                    onPressed: () {
                      context.push('/home/viewmore',
                          extra: movieProvider.tvSeriesOnTheAir);
                    },
                  ),
                  CarouselSliderWidget(
                    movies: movieProvider.tvSeriesOnTheAir,
                  ),
                  SectionButtonWidget(
                    title: 'Series Top Rates >',
                    onPressed: () {
                      context.push('/home/viewmore',
                          extra: movieProvider.tvTopRated);
                    },
                  ),
                  VerticalListWidget(
                    movies: movieProvider.tvTopRated,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
