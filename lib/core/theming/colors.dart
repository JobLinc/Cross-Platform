import 'package:flutter/material.dart';

class ColorsManager {
  // Light theme colors
  static const Color crimsonRed =
      Color(0xFFD72638); // Main buttons, highlights, brand color
  static const Color darkBurgundy =
      Color(0xFF780000); // Navbar, headers, strong contrast sections
  static const Color softDarkBurgundy =
      Color(0xA1780000); // for unselected elements
  static const Color softRosewood =
      Color(0xFFA52A2A); // Secondary buttons, borders, accents
  static const Color verySoftRosewood =
      Color.fromARGB(183, 226, 97, 97); // Text selection color
  static const Color lightGray =
      Color(0xFFF4F4F4); // Backgrounds, cards, subtle UI elements
  static const Color softMutedSilver =
      Color(0xA0F4F4F4); // tertiary color for appbars and fixed elements
  static const Color warmWhite =
      Color(0xFFFAFAFA); // Main background, clean space
  static const Color charcoalBlack =
      Color(0xFF222222); // Main text, high contrast for readability
  static const Color mutedSilver =
      Color(0xFFA0A0A0); // Secondary text, icons, minor details

  // Dark theme colors
  static const Color darkCrimsonRed =
      Color(0xFFFF3B4D); // Brighter red for dark mode
  static const Color darkModeBurgundy =
      Color(0xFF9E0013); // Lighter burgundy for dark mode
  static const Color darkModeRosewood =
      Color(0xFFD04545); // Brighter rosewood for dark mode
  static const Color darkModeBackground = Color(0xFF121212); // Dark background
  static const Color darkModeCardBackground =
      Color(0xFF1E1E1E); // Slightly lighter than background for cards
  static const Color darkModeTextPrimary =
      Color(0xFFEEEEEE); // Light text for dark background
  static const Color darkModeTextSecondary =
      Color(0xFFB0B0B0); // Secondary text for dark mode

  // Theme-aware getters for commonly used colors
  static Color getTextPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? charcoalBlack
        : darkModeTextPrimary;
  }

  static Color getTextSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? mutedSilver
        : darkModeTextSecondary;
  }

  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? warmWhite
        : darkModeBackground;
  }

  static Color getCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.white
        : darkModeCardBackground;
  }

  static Color getPrimaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? crimsonRed
        : darkCrimsonRed;
  }
}

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: lightColorScheme,
  hintColor: Colors.grey,
  unselectedWidgetColor: Colors.grey,
  focusColor: ColorsManager.darkBurgundy,
  iconTheme: IconThemeData(color: Colors.grey.shade700),
  dividerColor: Colors.grey,
  scaffoldBackgroundColor: ColorsManager.warmWhite,
  cardColor: Colors.white,
);

ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: ColorsManager.crimsonRed,
  onPrimary: ColorsManager.warmWhite,
  secondary: ColorsManager.darkBurgundy,
  onSecondary: ColorsManager.warmWhite,
  error: Colors.red,
  onError: Colors.white,
  background: ColorsManager.warmWhite,
  onBackground: ColorsManager.charcoalBlack,
  surface: ColorsManager.warmWhite,
  onSurface: ColorsManager.charcoalBlack,
);

// Add dark theme
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: darkColorScheme,
  hintColor: Colors.grey.shade400,
  unselectedWidgetColor: Colors.grey.shade600,
  focusColor: ColorsManager.darkModeBurgundy,
  iconTheme: IconThemeData(color: Colors.grey.shade300),
  dividerColor: Colors.grey.shade800,
  scaffoldBackgroundColor: ColorsManager.darkModeBackground,
  cardColor: ColorsManager.darkModeCardBackground,
);

ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: ColorsManager.darkCrimsonRed,
  onPrimary: ColorsManager.darkModeTextPrimary,
  secondary: ColorsManager.darkModeBurgundy,
  onSecondary: ColorsManager.darkModeTextPrimary,
  error: Colors.redAccent,
  onError: Colors.white,
  background: ColorsManager.darkModeBackground,
  onBackground: ColorsManager.darkModeTextPrimary,
  surface: ColorsManager.darkModeCardBackground,
  onSurface: ColorsManager.darkModeTextPrimary,
);
