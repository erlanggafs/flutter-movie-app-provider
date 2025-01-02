import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/utils/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  final Future<void> Function() onFinish;

  const OnBoardingScreen({Key? key, required this.onFinish}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
  }

  // Fungsi untuk meminta izin notifikasi
  Future<void> _requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Minta izin untuk notifikasi
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Permission granted");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("Permission granted provisionally");
    } else {
      print("Permission declined");
    }
  }

  void _onIntroEnd(BuildContext context) async {
    // Tandai onboarding selesai
    await widget.onFinish();
    // Navigasi ke halaman login setelah onboarding selesai
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "All the time, Anytime",
          body: "Gives you the freedom to watch the best films anywhere",
          image: Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/on1.png',
              width: 200,
            ),
          ),
          decoration: const PageDecoration(
            imageFlex: 2,
          ),
        ),
        PageViewModel(
          title: "Discover Trending Movies",
          body:
              "Get access to top Movies, trending movies, and exclusive content, all designed to keep you informed, wherever you go",
          image: Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/on2.png',
              width: 300,
            ),
          ),
          decoration: const PageDecoration(imageFlex: 2),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skip: const Text(
        'Lewati',
        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
      ),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Lebih Lanjut >",
          style:
              TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
    );
  }
}
