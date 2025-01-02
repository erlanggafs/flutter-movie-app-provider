import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/presentation/view_model/movie_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SavedMovieScreen extends StatefulWidget {
  @override
  _SavedMovieScreenState createState() => _SavedMovieScreenState();
}

class _SavedMovieScreenState extends State<SavedMovieScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchSavedMovies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh data when app comes back to the foreground
      _fetchSavedMovies();
    }
  }

  void _fetchSavedMovies() {
    final viewModel = Provider.of<MovieViewModel>(context, listen: false);
    viewModel.getMovieIsSavedFromDB();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.iconTheme.color,
        title: Text(
          'Saved Movies',
          style: TextStyle(color: textColor),
        ),
        centerTitle: true,
      ),
      body: Consumer<MovieViewModel>(
        builder: (context, movieProvider, child) {
          final movieIsSaved = movieProvider.moviesIsSaved;

          if (movieIsSaved.isEmpty) {
            return Center(
              child: Text(
                'No saved content available',
                style: TextStyle(color: textColor),
              ),
            );
          }

          return ListView.builder(
            itemCount: movieIsSaved.length,
            itemBuilder: (context, index) {
              final movie = movieIsSaved[index];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: theme.cardColor,
                  elevation: 5,
                  child: ListTile(
                    leading: movie.backDropPath != null
                        ? CachedNetworkImage(
                            imageUrl:
                                "https://image.tmdb.org/t/p/original/${movie.backDropPath}",
                            width: 100,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 100,
                                height: 56,
                                color: Colors.white,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.image),
                          )
                        : const Icon(Icons.image),
                    title: Text(
                      movie.title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: textColor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      'Release Date: ${movie.releaseDate.isNotEmpty ? movie.releaseDate : (movie.firstAirDate.isNotEmpty ? movie.firstAirDate : 'TBA')}',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                      ),
                    ),
                    onTap: () {
                      context.push('/home/detail', extra: movie);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
