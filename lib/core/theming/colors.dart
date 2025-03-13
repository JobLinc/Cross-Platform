import 'package:flutter/material.dart';

class ColorsManager {
  static const Color crimsonRed =
      Color(0xFFD72638); // Main buttons, highlights, brand color
  static const Color darkBurgundy =
      Color(0xFF780000); // Navbar, headers, strong contrast sections
  static const Color softDarkBurgundy =
      Color(0xA1780000); // for unselected elements
  static const Color softRosewood =
      Color(0xFFA52A2A); // Secondary buttons, borders, accents
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
}

ThemeData lightTheme = ThemeData(
  colorScheme: lightColorScheme,
  hintColor: Colors.grey,
  unselectedWidgetColor: Colors.grey,
  focusColor: ColorsManager.darkBurgundy,
  iconTheme: IconThemeData(color: Colors.grey.shade700),
  dividerColor: Colors.grey,
);

ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: ColorsManager.warmWhite,
  onPrimary: ColorsManager.charcoalBlack,
  secondary: ColorsManager.darkBurgundy,
  onSecondary: ColorsManager.charcoalBlack,
  error: Colors.black,
  onError: Colors.red,
  surface: Colors.brown.shade50,
  onSurface: ColorsManager.charcoalBlack,
);
