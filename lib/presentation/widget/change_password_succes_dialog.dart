import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Pastikan package ini ada di pubspec.yaml
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordSuccessDialog extends StatelessWidget {
  const ChangePasswordSuccessDialog({Key? key}) : super(key: key);

  Future<void> _logoutAndClearSession(BuildContext context) async {
    try {
      // Hapus sesi di SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Menghapus semua data sesi
      // Atau gunakan prefs.remove('key') untuk menghapus data tertentu

      // Logout dari Firebase
      await FirebaseAuth.instance.signOut();

      // Navigasi ke halaman login
      context.push('/login');
    } catch (e) {
      // Tangani error jika diperlukan
      print("Error saat logout: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sukses'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated Checklist
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 80,
          )
              .animate()
              .scale(
                duration: 800.ms,
                curve: Curves.bounceOut,
              )
              .fade(duration: 800.ms),
          const SizedBox(height: 16),
          const Text('Password berhasil diubah, silahkan login kembali'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await _logoutAndClearSession(context); // Panggil fungsi logout
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
