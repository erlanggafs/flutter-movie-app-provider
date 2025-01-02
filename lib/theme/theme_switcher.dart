import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dark_theme.dart';

class ThemeSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<UiTheme>(context, listen: false);
    return SwitchListTile(
      title: const Text("Dark Mode"),
      value: themeProvider.isDark,
      onChanged: (value) {
        themeProvider.changeTheme();
      },
    );
  }
}
