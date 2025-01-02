import 'package:flutter/material.dart';
import 'package:flutter_movie_app/utils/colors.dart';
import 'package:go_router/go_router.dart';

class RegistrationSuccessDialog extends StatelessWidget {
  const RegistrationSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 50),
            const SizedBox(height: 10),
            const Text('Registration Successful!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.go('/login'); // Navigasi ke halaman login
                context.pop(); // Menutup dialog setelah navigasi
              },
              child: const Text(
                'OK',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
