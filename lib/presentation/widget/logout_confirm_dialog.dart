import 'package:flutter/material.dart';
import 'package:flutter_movie_app/utils/colors.dart';
import 'package:go_router/go_router.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const LogoutConfirmationDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Konfirmasi Logout',
        style: TextStyle(fontSize: 20),
      ),
      content: const Text("Anda yakin ingin keluar?"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: AppColors.primary, width: 1),
      ),
      actions: [
        TextButton(
          onPressed: () {
            onConfirm(); // Memanggil fungsi logout yang diterima dari HomePage// Menutup dialog setelah logout
          },
          child: const Text("YA", style: TextStyle(color: AppColors.primary)),
        ),
        TextButton(
          onPressed: () {
            context.pop(); // Menutup dialog
          },
          child: const Text(
            "TIDAK",
            style: TextStyle(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
