import 'dart:async'; // Import untuk Timer

import 'package:flutter/material.dart';

import '../../firebase_handler/auth_repository.dart'; // Import repository untuk reset password

class ForgotPasswordViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  final TextEditingController forgotPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isButtonDisabled =
      false; // Variabel untuk menonaktifkan tombol sementara
  int remainingTime = 15; // Waktu mundur awal
  Timer? _timer; // Timer untuk hitung mundur

  // Fungsi validasi email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  // Fungsi untuk memulai timer hitung mundur
  void startCountdown() {
    remainingTime = 15;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        remainingTime--;
        notifyListeners(); // Memperbarui tampilan setiap detik
      } else {
        _timer?.cancel(); // Hentikan timer setelah waktu habis
      }
    });
  }

  // Fungsi untuk menonaktifkan tombol dan mulai hitung mundur
  void onButtonPressed(BuildContext context) {
    if (formKey.currentState!.validate()) {
      // Pastikan email valid
      isButtonDisabled = true;
      notifyListeners(); // Memperbarui tampilan tombol

      // Panggil fungsi reset password dari viewModel
      resetPassword(context);

      // Mulai hitung mundur
      startCountdown();

      // Aktifkan kembali tombol setelah 15 detik
      Future.delayed(const Duration(seconds: 15), () {
        isButtonDisabled = false;
        notifyListeners(); // Memperbarui tampilan tombol
      });
    }
  }

  // Fungsi untuk reset password
  Future<void> resetPassword(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      try {
        await _authRepository.sendPasswordResetEmail(
          forgotPasswordController.text.trim(),
          context,
        );
      } catch (e) {
        // Tangani error jika diperlukan
        debugPrint(e.toString());
      }
    }
  }

  @override
  void dispose() {
    forgotPasswordController.dispose();
    _timer?.cancel(); // Membatalkan timer ketika dispose
    super.dispose();
  }
}
