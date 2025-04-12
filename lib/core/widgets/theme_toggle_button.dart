import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:joblinc/core/theming/theme_provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return IconButton(
      icon: Icon(
        isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
        color: Theme.of(context).iconTheme.color,
      ),
      onPressed: () {
        themeProvider.toggleTheme();
      },
      tooltip: isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
    );
  }
}
