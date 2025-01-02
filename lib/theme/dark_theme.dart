import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UiTheme extends ChangeNotifier {
  bool _isDark = false;
  bool _useSystemTheme = true;

  bool get isDark => _useSystemTheme
      ? PlatformDispatcher.instance.platformBrightness == Brightness.dark
      : _isDark;

  late SharedPreferences storage;

  // Dark theme settings
  final darkTheme = ThemeData(
    primaryColor: Colors.black12,
    brightness: Brightness.dark,
    primaryColorDark: Colors.black12,
  );

  // Light theme settings
  final lightTheme = ThemeData(
    primaryColor: Colors.white,
    brightness: Brightness.light,
    primaryColorDark: Colors.white,
  );

  // Initialize theme preferences
  init() async {
    storage = await SharedPreferences.getInstance();
    _useSystemTheme = storage.getBool("useSystemTheme") ?? true;
    _isDark = storage.getBool("isDark") ?? false;
    notifyListeners();
  }

  // Change theme (manual toggle)
  changeTheme() {
    _useSystemTheme = false;
    _isDark = !_isDark;
    storage.setBool("useSystemTheme", _useSystemTheme);
    storage.setBool("isDark", _isDark);
    notifyListeners();
  }

  // Use system theme
  useSystemTheme() {
    _useSystemTheme = true;
    storage.setBool("useSystemTheme", _useSystemTheme);
    notifyListeners();
  }
}
