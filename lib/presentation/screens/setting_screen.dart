import 'package:flutter/material.dart';
import 'package:flutter_movie_app/theme/dark_theme.dart';
import 'package:flutter_movie_app/utils/colors.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen Theme'),
      ),
      body: Consumer<UiTheme>(
        builder: (context, UiTheme notifier, child) {
          return Column(
            children: [
              ListTile(
                leading: Icon(
                  notifier.isDark ? Icons.dark_mode : Icons.light_mode,
                ),
                trailing: Switch(
                  value: notifier.isDark,
                  onChanged: (value) {
                    notifier.changeTheme();
                  },
                  activeColor: AppColors.primary, // Color when switch is ON
                  inactiveThumbColor: Colors.grey, // Color when switch is OFF
                  inactiveTrackColor:
                      Colors.black12, // Track color when switch is OFF
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
