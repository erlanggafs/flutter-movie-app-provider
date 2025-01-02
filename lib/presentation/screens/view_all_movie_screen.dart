import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/data/model/movie_model.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ViewAllMoreContentScreen extends StatefulWidget {
  final List<Movie> movies; // Menambahkan parameter untuk list movies
  final String title; // Menambahkan parameter untuk title

  const ViewAllMoreContentScreen({
    super.key,
    required this.movies, // Inisialisasi parameter movies
    required this.title, // Inisialisasi parameter title
  });

  @override
  State<ViewAllMoreContentScreen> createState() =>
      _ViewAllMoreContentScreenState();
}

class _ViewAllMoreContentScreenState extends State<ViewAllMoreContentScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white // Jika tema gelap, gunakan warna putih
        : Colors.black;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            theme.appBarTheme.backgroundColor, // Use appBar background color
        foregroundColor: theme.iconTheme.color,
        centerTitle: false,
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(color: textColor),
        ), // Menampilkan title dari parameter
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount:
              widget.movies.length, // Menggunakan widget.movies yang diterima
          itemBuilder: (context, index) {
            final movie =
                widget.movies[index]; // Mengakses data movie dari widget.movies
            return Card(
              color: theme.cardColor,
              elevation: 5,
              child: ListTile(
                contentPadding: EdgeInsets.all(10),
                leading: movie.posterPath != null
                    ? CachedNetworkImage(
                        imageUrl:
                            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                        width: 100,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 100,
                            height: 150,
                            color: Colors.white,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )
                    : const SizedBox(
                        width: 100,
                      ), // Jika tidak ada gambar, beri ruang kosong
                title: Text(
                  movie.title,
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
                subtitle: Text(
                  movie.overview,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: textColor),
                ),
                onTap: () {
                  context.push('/home/detail', extra: movie);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
