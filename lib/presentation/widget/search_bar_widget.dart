import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/model/movie_model.dart';

class MovieSearchDelegate extends SearchDelegate {
  final List<Movie> allMovies;
  final Function(String) onQueryChanged;

  MovieSearchDelegate({
    required this.allMovies,
    required this.onQueryChanged,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Reset query
          onQueryChanged(query); // Reset hasil pencarian
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, allMovies); // Menutup pencarian
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white // Jika tema gelap, gunakan warna putih
        : Colors.black;

    final results = allMovies
        .where((movie) {
          return movie.title.toLowerCase().contains(query.toLowerCase()) ||
              movie.id.toString().contains(query);
        })
        .toList()
        .fold<Map<int, Movie>>({}, (map, movie) {
          map[movie.id] = movie;
          return map;
        })
        .values
        .toList();

    return Scaffold(
      backgroundColor: theme
          .scaffoldBackgroundColor, // Ganti dengan warna yang kamu inginkan
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final movie = results[index];
          return GestureDetector(
            onTap: () {
              context.push('/home/detail', extra: movie);
            },
            child: Card(
              color: theme.cardColor,
              elevation: 2,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 120,
                      height: 90,
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://image.tmdb.org/t/p/original/${movie.backDropPath}",
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 120,
                            height: 90,
                            color:
                                Colors.grey[300], // Warna shimmer placeholder
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.error, // Widget jika gagal memuat gambar
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Release Date: ${movie.releaseDate.isNotEmpty ? movie.releaseDate : (movie.firstAirDate.isNotEmpty ? movie.firstAirDate : 'TBA')}',
                            style: TextStyle(
                              fontSize: 12,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.smart_display,
                                  color: Colors.red, size: 16),
                              const SizedBox(width: 5),
                              Text(
                                movie.popularity.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white // Jika tema gelap, gunakan warna putih
        : Colors.black;
    final suggestions = query.isEmpty
        ? allMovies
        : allMovies
            .where((movie) {
              return movie.title.toLowerCase().contains(query.toLowerCase()) ||
                  movie.id.toString().contains(query);
            })
            .toList()
            .fold<Map<int, Movie>>({}, (map, movie) {
              map[movie.id] = movie;
              return map;
            })
            .values
            .toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final movie = suggestions[index];
          return GestureDetector(
            onTap: () {
              context.push('/home/detail', extra: movie);
            },
            child: Card(
              elevation: 2,
              color: theme.cardColor,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 120,
                      height: 90,
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://image.tmdb.org/t/p/original/${movie.backDropPath}",
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 120,
                            height: 90,
                            color:
                                Colors.grey[300], // Warna shimmer placeholder
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.error, // Widget jika gagal memuat gambar
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Release Date: ${movie.releaseDate.isNotEmpty ? movie.releaseDate : (movie.firstAirDate.isNotEmpty ? movie.firstAirDate : 'TBA')}',
                            style: TextStyle(
                              fontSize: 12,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.smart_display,
                                  color: Colors.red, size: 16),
                              const SizedBox(width: 5),
                              Text(
                                movie.popularity.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
