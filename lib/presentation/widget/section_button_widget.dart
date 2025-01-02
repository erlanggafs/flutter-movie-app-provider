import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const SectionButtonWidget(
      {Key? key, required this.title, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ambil warna teks dari theme yang sedang digunakan
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white // Jika tema gelap, gunakan warna putih
        : Colors.black; // Jika tema terang, gunakan warna hitam

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: GoogleFonts.poppins(
            color: textColor, // Menggunakan warna berdasarkan tema
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
