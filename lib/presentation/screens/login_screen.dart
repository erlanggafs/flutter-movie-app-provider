import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/presentation/widget/costum_textfield.dart';
import 'package:flutter_movie_app/utils/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../view_model/login_view_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _obscurePassword = true; // Menyembunyikan password secara default

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);

    // Mengambil warna teks berdasarkan tema aktif
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2.5,
            decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(70)),
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Moview',
                          style: GoogleFonts.pacifico(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 50),
                        ),
                        Text(
                          'Smart Watching',
                          style: GoogleFonts.poppins(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              left: 20,
            ),
            child: Text(
              'Silahkan Masuk',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: textColor, // Menggunakan warna dari tema
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  labelText: 'Email',
                  obscureText: false,
                  errorText: loginViewModel.emailError,
                  prefixIcon: Icons.email,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  labelText: 'Password',
                  obscureText: _obscurePassword,
                  errorText: loginViewModel.passwordError,
                  prefixIcon: Icons.vpn_key,
                  suffixIcon: _obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  onSuffixIconPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.push('/forgotPassword');
                      },
                      child: Text(
                        'Lupa Password ?',
                        style: TextStyle(
                            color: textColor), // Dinamis berdasarkan tema
                      ),
                    ),
                  ],
                ),
                loginViewModel.isLoading
                    ? SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white),
                          onPressed: null, // disable button saat loading
                          child: const CircularProgressIndicator(),
                        ),
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white),
                          onPressed: () async {
                            User? user =
                                await loginViewModel.signInWithEmailPassword(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                            if (user != null) {
                              context.go('/main');
                            }
                          },
                          child: const Text('Login',
                              style: TextStyle(fontSize: 15)),
                        ),
                      ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    User? user = await loginViewModel.signInWithGoogle();
                    if (user != null) {
                      context.go('/main');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 24.0),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    side: BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/icon_google.png',
                        height: 24.0,
                        width: 24.0,
                      ),
                      const SizedBox(width: 8.0),
                      const Text(
                        'Sign In with Google',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                          color: textColor), // Dinamis berdasarkan tema
                    ),
                    TextButton(
                      onPressed: () {
                        context.push('/register');
                      },
                      child: Text('Register Now',
                          style: TextStyle(color: AppColors.primary)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
