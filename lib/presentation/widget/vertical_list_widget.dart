import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/data/model/movie_model.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class VerticalListWidget extends StatefulWidget {
  final List<Movie> movies;

  const VerticalListWidget({
    super.key,
    required this.movies,
  });

  @override
  _VerticalListWidgetState createState() => _VerticalListWidgetState();
}

class _VerticalListWidgetState extends State<VerticalListWidget> {
  @override
  Widget build(BuildContext context) {
    // Mendapatkan warna yang sesuai dengan tema yang aktif
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkTheme ? Colors.white : Colors.black;
    final subTextColor = isDarkTheme ? Colors.white70 : Colors.black87;
    final cardColor = isDarkTheme ? Colors.black : Colors.white;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: widget.movies.length > 5 ? 5 : widget.movies.length,
        itemBuilder: (context, index) {
          final movie = widget.movies[index];

          return GestureDetector(
            onTap: () {
              context.push('/home/detail', extra: movie);
            },
            child: Card(
              color: cardColor, // Gunakan warna card sesuai tema
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 100,
                      height: 140,
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://image.tmdb.org/t/p/original/${movie.backDropPath}",
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor, // Warna teks sesuai tema
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            movie.overview,
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  subTextColor, // Warna teks deskripsi sesuai tema
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.smart_display, color: textColor),
                              const SizedBox(width: 5),
                              Text(
                                movie.popularity.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      subTextColor, // Warna sub teks sesuai tema
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.star,
                                  size: 20, color: Colors.amber),
                              Text(
                                movie.voteAverage.toStringAsFixed(1),
                                style: TextStyle(
                                    color: textColor), // Warna teks sesuai tema
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
