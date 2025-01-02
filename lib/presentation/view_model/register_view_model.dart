// viewmodels/auth_viewmodel.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/data/model/auth.dart';

class RegisterViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;
  String nameError = ''; // Error untuk name
  String emailError = '';
  String passwordError = '';

  // Validasi email
  bool _isEmailValid(String email) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }

  // Validasi password
  bool _isPasswordValid(String password) {
    return password.length >= 6;
  }

  // Validasi name
  bool _isNameValid(String name) {
    // Menyaring nama yang tidak kosong
    return name.isNotEmpty;
  }

  // Fungsi registrasi
  Future<User?> register(UserModel user) async {
    isLoading = true;
    emailError = '';
    passwordError = '';
    nameError = ''; // Reset name error
    notifyListeners();

    // Validasi name
    if (!_isNameValid(user.name)) {
      isLoading = false;
      nameError = "Name cannot be empty"; // Error name
      notifyListeners();
      return null;
    }

    // Validasi email
    if (!_isEmailValid(user.email)) {
      isLoading = false;
      emailError = "Invalid email format";
      notifyListeners();
      return null;
    }

    // Validasi password
    if (!_isPasswordValid(user.password)) {
      isLoading = false;
      passwordError = "Password must be at least 6 characters";
      notifyListeners();
      return null;
    }

    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      isLoading = false;
      notifyListeners();

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      if (e.code == 'email-already-in-use') {
        emailError = "The email address is already in use by another account";
      } else {
        emailError = "An error occurred. Please try again.";
      }
      notifyListeners();
      return null;
    }
  }
}
