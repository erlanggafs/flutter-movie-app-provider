import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/data/model/movie_model.dart';
import 'package:flutter_movie_app/presentation/screens/change_password_screen.dart';
import 'package:flutter_movie_app/presentation/screens/detail_screen.dart';
import 'package:flutter_movie_app/presentation/screens/forgot_password_screen.dart';
import 'package:flutter_movie_app/presentation/screens/home_screen.dart';
import 'package:flutter_movie_app/presentation/screens/login_screen.dart';
import 'package:flutter_movie_app/presentation/screens/main_screen.dart';
import 'package:flutter_movie_app/presentation/screens/onboarding_screen.dart';
import 'package:flutter_movie_app/presentation/screens/register_screen.dart';
import 'package:flutter_movie_app/presentation/screens/splash_screen.dart';
import 'package:flutter_movie_app/presentation/screens/view_all_movie_screen.dart';
import 'package:flutter_movie_app/presentation/widget/custom_transition.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../presentation/screens/profile_account_screen.dart';
import '../presentation/screens/setting_screen.dart';
import '../presentation/screens/video_player_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

GoRouter createRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: '/splash',
    redirect: (BuildContext context, GoRouterState state) async {
      final User? user = FirebaseAuth.instance.currentUser;
      final prefs = await SharedPreferences.getInstance();
      final isFirstLaunch = prefs.getBool('isFirstLaunch');

      if (state.matchedLocation == '/splash') {
        return null;
      }

      final nonAuthRoutes = ['/login', '/forgotPassword', '/register'];

      if (isFirstLaunch == null) {
        return '/onboarding';
      }

      if (user == null && !nonAuthRoutes.contains(state.matchedLocation)) {
        return '/login';
      }

      // if (user == null) {
      //   return '/login';
      // }
      //
      // if (isFirstLaunch == true) {
      //   return '/onboarding';
      // }
      //
      // if (isFirstLaunch == false) {
      //   return '/home';
      // }
      //
      // final nonAuthRoutes = ['/login', '/forgotPassword', '/register'];
      //   if (nonAuthRoutes.contains(state.matchedLocation)) {
      //     return null;
      //   }

      //
      // if (state.matchedLocation == '/main') {
      //   if (isFirstLaunch) {
      //     return '/onboarding';
      //   }
      //
      //   if (user == null) {
      //     return '/login';
      //   }
      //
      //   final nonAuthRoutes = ['/login', '/forgotPassword', '/register'];
      //   if (nonAuthRoutes.contains(state.matchedLocation)) {
      //     return null;
      //   }
      //
      //   return null;
      // }

      // // Jika sedang di halaman splash dan belum menunjukkan splash screen
      //
      // // Setelah splash screen, gunakan logika redirect normal
      // if (state.matchedLocation != '/splash') {
      //   final User? user = FirebaseAuth.instance.currentUser;
      //   final prefs = await SharedPreferences.getInstance();
      //   final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
      //
      //   // Izinkan akses ke Onboarding jika first launch
      //   if (isFirstLaunch) {
      //     return '/onboarding';
      //   }
      //
      //   // Izinkan akses ke halaman non-auth tanpa redirect
      //   final nonAuthRoutes = ['/login', '/forgotPassword', '/register'];
      //   if (nonAuthRoutes.contains(state.matchedLocation)) {
      //     return null;
      //   }
      //
      //   // Redirect ke login jika belum login
      //   if (user == null) {
      //     return '/login';
      //   }
      // }

      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => OnBoardingScreen(
          onFinish: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isFirstLaunch', false);
            context.go('/login');
          },
        ),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => slideTransitionPage(
          key: state.pageKey,
          child: LoginScreen(),
          beginOffset: const Offset(-1.0, 0.0),
        ),
      ),
      GoRoute(
        path: '/forgotPassword',
        builder: (context, state) => ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/changepassword',
        builder: (context, state) => ChangePasswordScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
        path: '/main',
        builder: (context, state) => MainScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => HomeScreen(),
        routes: [
          GoRoute(
            path: 'detail',
            builder: (context, state) {
              final movie = state.extra as Movie;
              return MovieDetailScreen(movie: movie);
            },
            routes: [
              GoRoute(
                path: 'videoPlayer/:videoKey',
                builder: (context, state) {
                  final videoKey = state.pathParameters['videoKey']!;
                  return VideoPlayerScreen(videoKey: videoKey);
                },
              ),
            ],
          ),
          GoRoute(
            path: 'viewmore',
            builder: (context, state) {
              final movies = state.extra as List<Movie>;
              final title = state.uri.queryParameters['title'] ?? 'More';
              return ViewAllMoreContentScreen(
                movies: movies,
                title: title,
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => ProfileAccountScreen(title: ''),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => SettingScreen(),
      ),
    ],
  );
}
