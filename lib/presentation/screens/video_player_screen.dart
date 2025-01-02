import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk mengatur orientasi layar
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoKey; // Menyimpan key video dari API

  VideoPlayerScreen({required this.videoKey});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Memaksa orientasi layar menjadi lanskap saat memutar video
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight, // Lanskap kanan
      DeviceOrientation.landscapeLeft, // Lanskap kiri
    ]);

    // Inisialisasi controller untuk video YouTube
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoKey, // Menggunakan key video dari API
      flags: const YoutubePlayerFlags(
        autoPlay: true, // Memulai pemutaran otomatis
        mute: false, // Tidak di-mute
      ),
    );
  }

  @override
  void dispose() {
    // Mengembalikan orientasi layar ke potret ketika keluar dari video
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, // Potret atas
      DeviceOrientation.portraitDown, // Potret bawah
    ]);

    // Pastikan controller dibersihkan setelah halaman ditutup
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ukuran layar tetap, tetapi dengan rasio aspek tetap 16:9
    final screenSize = MediaQuery.of(context).size;
    final aspectRatio = 16 / 9; // Rasio 16:9 yang digunakan untuk video

    return Scaffold(
      // appBar: AppBar(title: Text('Trailer')),
      body: Column(
        children: [
          // Menggunakan Expanded agar video player mengikuti ukuran layar
          Expanded(
            child: YoutubePlayer(
              controller: _controller,
              liveUIColor: Colors.amber,
              aspectRatio: aspectRatio, // Menyesuaikan dengan rasio 16:9
            ),
          ),
        ],
      ),
    );
  }
}
