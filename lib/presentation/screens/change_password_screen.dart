import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk FilteringTextInputFormatter
import 'package:flutter_movie_app/utils/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../view_model/change_password_view_model.dart'; // Untuk Fluttertoast

class ChangePasswordScreen extends StatelessWidget {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final passwordChangeProvider =
        Provider.of<ChangePasswordViewModel>(context);

    // Mengambil warna teks berdasarkan tema aktif

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: const Text(
          'Ubah Password',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPasswordField(
              label: 'Password Lama',
              controller: _oldPasswordController,
              isVisible: passwordChangeProvider.isOldPasswordVisible,
              errorText: passwordChangeProvider.oldPasswordError,
              onVisibilityToggle:
                  passwordChangeProvider.toggleOldPasswordVisibility,
            ),
            const SizedBox(height: 15),
            _buildPasswordField(
              label: 'Password Baru',
              controller: _newPasswordController,
              isVisible: passwordChangeProvider.isNewPasswordVisible,
              errorText: passwordChangeProvider.newPasswordError,
              onVisibilityToggle:
                  passwordChangeProvider.toggleNewPasswordVisibility,
            ),
            const SizedBox(height: 15),
            _buildPasswordField(
              label: 'Konfirmasi Password Baru',
              controller: _confirmPasswordController,
              isVisible: passwordChangeProvider.isConfirmPasswordVisible,
              errorText: passwordChangeProvider.confirmPasswordError,
              onVisibilityToggle:
                  passwordChangeProvider.toggleConfirmPasswordVisibility,
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppColors.primary,
                ),
                onPressed: passwordChangeProvider.isLoading
                    ? null
                    : () async {
                        try {
                          await passwordChangeProvider.changePassword(
                            _oldPasswordController.text,
                            _newPasswordController.text,
                            _confirmPasswordController.text,
                            context,
                          );
                        } catch (e) {
                          Fluttertoast.showToast(
                            msg: "Terjadi kesalahan: $e",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                        }
                      },
                child: passwordChangeProvider.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Ubah Password'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool isVisible,
    String? errorText,
    required VoidCallback onVisibilityToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14)),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: TextField(
            controller: controller,
            obscureText: !isVisible,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade400,
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              suffixIcon: IconButton(
                icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
                color: Colors.grey.shade700,
                onPressed: onVisibilityToggle,
              ),
              errorText: errorText,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'\s')), // Menolak spasi
            ],
            style: TextStyle(color: Colors.black),
            keyboardType: TextInputType.text, // Menentukan tipe keyboard
          ),
        ),
      ],
    );
  }
}
