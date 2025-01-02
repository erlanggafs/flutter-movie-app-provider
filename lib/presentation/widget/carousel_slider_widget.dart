import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/data/model/movie_model.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class CarouselSliderWidget extends StatefulWidget {
  final List<Movie> movies;

  const CarouselSliderWidget({
    super.key,
    required this.movies,
  });

  @override
  _CarouselSliderWidgetState createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada film untuk ditampilkan',
          style: TextStyle(fontSize: 18),
        ),
      );
    }
    return CarouselSlider.builder(
      itemCount: widget.movies.length > 7 ? 7 : widget.movies.length,
      itemBuilder: (context, index, movieIndex) {
        final movie = widget.movies[index];
        return GestureDetector(
          onTap: () {
            context.push('/home/detail', extra: movie);
          },
          child: CachedNetworkImage(
            imageUrl:
                "https://image.tmdb.org/t/p/original/${movie.backDropPath}",
            imageBuilder: (context, imageProvider) => Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    child: Column(
                      children: [
                        Text(
                          movie.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          movie.releaseDate ?? 'Tanggal tidak tersedia',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 50,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gagal memuat gambar',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 2,
        autoPlayInterval: const Duration(seconds: 3),
      ),
    );
  }
}
