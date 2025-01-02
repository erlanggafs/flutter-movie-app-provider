import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/presentation/widget/change_password_succes_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePasswordViewModel with ChangeNotifier {
  String? _errorMessage;
  bool _isLoading = false;
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? oldPasswordError;
  String? newPasswordError;
  String? confirmPasswordError;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isOldPasswordVisible => _isOldPasswordVisible;
  bool get isNewPasswordVisible => _isNewPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  // Toggle password visibility
  void toggleOldPasswordVisibility() {
    _isOldPasswordVisible = !_isOldPasswordVisible;
    notifyListeners();
  }

  void toggleNewPasswordVisibility() {
    _isNewPasswordVisible = !_isNewPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  Future<void> changePassword(String oldPassword, String newPassword,
      String confirmPassword, BuildContext context) async {
    _clearErrors();

    // Validate inputs
    if (_validateInputs(oldPassword, newPassword, confirmPassword)) {
      _setLoading(true);

      // Reauthenticate the user with old password
      if (!await reauthenticate(oldPassword)) {
        _setLoading(false);
        return;
      }

      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await user.updatePassword(newPassword);
          await user.reload();
          _setLoading(false);
          _showSuccessDialog(context);
        }
      } catch (e) {
        _errorMessage = e.toString();
        notifyListeners();
        // Tampilkan toast jika terjadi error
        Fluttertoast.showToast(
          msg: "Terjadi kesalahan: $_errorMessage",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }

      _setLoading(false);
    }
  }

  Future<bool> reauthenticate(String oldPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(credential);
      return true;
    } catch (e) {
      _errorMessage = "Password lama tidak sesuai";
      notifyListeners();
      // Tampilkan toast jika reauth gagal
      Fluttertoast.showToast(
        msg: _errorMessage!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  bool _validateInputs(
      String oldPassword, String newPassword, String confirmPassword) {
    bool isValid = true;

    if (oldPassword.isEmpty) {
      oldPasswordError = 'Password lama harus diisi';
      isValid = false;
    }
    if (newPassword.isEmpty) {
      newPasswordError = 'Password baru harus diisi';
      isValid = false;
    }
    if (confirmPassword.isEmpty) {
      confirmPasswordError = 'Konfirmasi password baru harus diisi';
      isValid = false;
    } else if (newPassword != confirmPassword) {
      confirmPasswordError = 'Password baru dan konfirmasi tidak cocok';
      isValid = false;
    }

    if (!isValid) {
      Fluttertoast.showToast(
        msg: "Validasi input gagal. Periksa kembali.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
    }

    notifyListeners();
    return isValid;
  }

  void _clearErrors() {
    oldPasswordError = null;
    newPasswordError = null;
    confirmPasswordError = null;
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => ChangePasswordSuccessDialog(),
    );
  }
}
