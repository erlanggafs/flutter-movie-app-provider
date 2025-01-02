// lib/view_models/login_view_model.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/firebase_handler/auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  bool isLoading = false;
  String emailError = '';
  String passwordError = '';

  Future<User?> signInWithEmailPassword(String email, String password) async {
    emailError = '';
    passwordError = '';
    isLoading = true;
    notifyListeners();

    if (email.isEmpty) {
      emailError = 'Email is required';
      isLoading = false;
      notifyListeners();
      return null;
    }

    if (password.isEmpty) {
      passwordError = 'Password is required';
      isLoading = false;
      notifyListeners();
      return null;
    }

    try {
      final user =
          await _authRepository.signInWithEmailPassword(email, password);
      isLoading = false;
      notifyListeners();
      return user;
    } catch (e) {
      passwordError = 'Incorrect email or password';
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<User?> signInWithGoogle() async {
    isLoading = true;
    notifyListeners();

    try {
      final user = await _authRepository.signInWithGoogle();
      isLoading = false;
      notifyListeners();
      return user;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return null;
    }
  }
}
