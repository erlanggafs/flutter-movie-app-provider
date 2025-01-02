import 'package:flutter/material.dart';
import 'package:flutter_movie_app/presentation/screens/home_screen.dart';
import 'package:flutter_movie_app/presentation/screens/setting_screen.dart';

import '../../utils/colors.dart';
import 'profile_account_screen.dart';
import 'saved_movie_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;

  // Create pages only once and keep them in memory
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;

    // Initialize pages once
    _pages = [
      const HomeScreen(),
      SavedMovieScreen(),
      ProfileAccountScreen(title: ''),
      const SettingScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: _pages[_selectedIndex], // Langsung gunakan _pages[_selectedIndex]
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.scaffoldBackgroundColor,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        elevation: 2,
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Perbarui halaman
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
