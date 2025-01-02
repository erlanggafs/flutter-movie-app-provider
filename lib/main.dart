import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_movie_app/presentation/view_model/change_password_view_model.dart';
import 'package:flutter_movie_app/presentation/view_model/forgot_password_view_model.dart';
import 'package:flutter_movie_app/presentation/view_model/login_view_model.dart';
import 'package:flutter_movie_app/presentation/view_model/movie_view_model.dart';
import 'package:flutter_movie_app/presentation/view_model/register_view_model.dart';
import 'package:flutter_movie_app/presentation/view_model/user_profile_view_model.dart';
import 'package:flutter_movie_app/routes/app_routes.dart';
import 'package:flutter_movie_app/theme/dark_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'data/local_datasource/database/app_database.dart';

var logger = Logger();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  logger.d("Handling a background message: ${message.messageId}");

  if (message.notification != null) {
    logger.i('Notification Title: ${message.notification!.title}');
    logger.i('Notification Body: ${message.notification!.body}');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  // Atur status bar transparan
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
  );

  // Inisialisasi Firebase
  await Firebase.initializeApp();
  logger.i("Firebase initialized");

  // Rekam error fatal di Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    logger.e("Fatal error: $error");
    return true;
  };

  // Inisialisasi Floor Database
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  logger.i("Floor Database initialized");

  // Daftarkan handler pesan background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final GoRouter _router = createRouter();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UiTheme()..init()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(
            create: (_) => UserProfileViewModel(database.userProfileDao)),
        ChangeNotifierProvider(create: (_) => ChangePasswordViewModel()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(
          create: (context) => MovieViewModel(),
        ),
      ],
      child: MyApp(router: _router),
    ),
  );
}

class MyApp extends StatelessWidget {
  final GoRouter router;

  const MyApp({Key? key, required this.router}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UiTheme>(builder: (context, UiTheme notifier, child) {
      return MaterialApp.router(
        routerConfig: router,
        theme: notifier.lightTheme,
        darkTheme: notifier.darkTheme,
        themeMode: notifier.isDark ? ThemeMode.dark : ThemeMode.light,
        debugShowCheckedModeBanner: false,
      );
    });
  }
}
