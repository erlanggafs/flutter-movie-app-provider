import 'package:cached_network_image/cached_network_image.dart'; // Import package cached_network_image
import 'package:flutter/material.dart'; // Jika menggunakan SharedPreferences
import 'package:flutter_movie_app/presentation/view_model/movie_view_model.dart';
import 'package:flutter_movie_app/utils/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/model/movie_model.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool _isExpanded = false;
  bool _isLoading = false; // Menambahkan variabel untuk status bookmark

  // Fungsi untuk menyimpan data film

  Future<void> _shareURL(String movieId) async {
    final deepLinkUrl = "myapp://example.com/detail/$movieId";
    try {
      await Share.share(
        deepLinkUrl,
        subject: "Check out this movie: ${widget.movie.id}!",
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white // Jika tema gelap, gunakan warna putih
        : Colors.black;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(
          widget.movie.title,
          style: TextStyle(color: themeColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar film menggunakan CachedNetworkImage
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl:
                      "https://image.tmdb.org/t/p/original/${widget.movie.backDropPath}",
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              const SizedBox(height: 12),
              // Judul film
              Text(
                widget.movie.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: themeColor,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Center(
                        child: IconButton(
                          onPressed: () {
                            // Menavigasi ke halaman pemutar video
                            context
                                .push('/home/detail/videoPlayer/2YI2RnhnmRo');
                          },
                          icon: Icon(
                            Icons.movie_creation_outlined,
                            color: themeColor,
                            size: 35,
                          ),
                          splashColor:
                              AppColors.primary, // Menambahkan splash color
                        ),
                      ),
                      Text(
                        'Trailer',
                        style: TextStyle(color: themeColor),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Center(
                        child: Consumer<MovieViewModel>(
                          builder: (context, movieProvider, child) {
                            final currentMovie =
                                movieProvider.allMovies.firstWhere(
                              (movie) => movie.id == widget.movie.id,
                              orElse: () => widget.movie,
                            );
                            return IconButton(
                              onPressed: () async {
                                try {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  await Provider.of<MovieViewModel>(context,
                                          listen: false)
                                      .updateMovietoDB(currentMovie);

                                  setState(() {
                                    currentMovie.isSaved =
                                        !currentMovie.isSaved;
                                  });
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Failed to save: ${e.toString()}')),
                                    );
                                  }
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                              },
                              icon: Icon(
                                currentMovie.isSaved
                                    ? Icons.bookmark
                                    : Icons.bookmark_outline,
                                color: currentMovie.isSaved
                                    ? Colors.red
                                    : themeColor,
                                size: 35,
                              ),
                            );
                          },
                        ),
                      ),
                      Text(
                        'Watch Later',
                        style: TextStyle(color: themeColor),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Center(
                        child: IconButton(
                          splashColor: AppColors.primary,
                          onPressed: () {
                            _shareURL(widget.movie.title);
                          },
                          icon: Icon(
                            Icons.share_outlined,
                            color: themeColor,
                            size: 35,
                          ),
                        ),
                      ),
                      Text(
                        'Share',
                        style: TextStyle(color: themeColor),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.star, size: 20, color: Colors.amber),
                  Text(
                    widget.movie.voteAverage.toStringAsFixed(1),
                    style: TextStyle(color: themeColor),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.smart_display, color: themeColor),
                  const SizedBox(width: 5),
                  Text(
                    widget.movie.popularity.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: themeColor,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                "Genre: ${widget.movie.genreNames.isNotEmpty ? widget.movie.genreNames.join(", ") : "-"}",
                style: TextStyle(
                  fontSize: 16,
                  color: themeColor,
                ),
              ),
              // Tanggal rilis film
              Text(
                'Release Date: ${widget.movie.releaseDate.isNotEmpty ? widget.movie.releaseDate : (widget.movie.firstAirDate.isNotEmpty ? widget.movie.firstAirDate : 'TBA')}',
                style: TextStyle(fontSize: 16, color: themeColor),
              ),
              Text(
                'Language : ${widget.movie.originalLanguage ?? 'TBA'}',
                style: TextStyle(fontSize: 16, color: themeColor),
              ),
              SizedBox(height: 12),
              // Deskripsi film dengan GestureDetector
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded =
                        !_isExpanded; // Toggle state untuk ekspansi teks
                  });
                },
                child: Text(
                  _isExpanded
                      ? widget.movie.overview
                      : (widget.movie.overview.length) > 180
                          ? '${widget.movie.overview.substring(0, 180)}...'
                          : widget.movie.overview ??
                              'No description available.',
                  style: TextStyle(fontSize: 16, color: themeColor),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
