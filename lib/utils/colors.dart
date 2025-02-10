import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class AppColors {
  static Color getPrimaryColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return themeProvider.isDarkMode
        ? Color(0xFF1976D2)  // Dark mode primary color
        : Color(0xFF0D47A1); // Light mode primary color
  }

  //Color(0xFF022358), Color(0xFF000000)

  static Color getSecondaryColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return themeProvider.isDarkMode
        ? Color(0xFF64B5F6)  // Dark mode secondary color
        : Color(0xFF42A5F5); // Light mode secondary color
  }

  static Color getAccentColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return themeProvider.isDarkMode
        ? Color(0xFF388E3C)  // Dark mode accent color
        : Color(0xFF4CAF50); // Light mode accent color
  }

  static Color getBackgroundColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return themeProvider.isDarkMode
        ? Color(0xFF121212)  // Dark mode background
        : Color(0xFFF5F5F5); // Light mode background
  }

  static Color getTextColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return themeProvider.isDarkMode
        ? Color(0xFFE0E0E0)  // Dark mode text color
        : Color(0xFF212121); // Light mode text color
  }

  static Color getErrorColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return themeProvider.isDarkMode
        ? Color(0xFFEF5350)  // Dark mode error color
        : Color(0xFFD32F2F); // Light mode error color
  }

  static LinearGradient getGradient(BuildContext context, {AlignmentGeometry begin = Alignment.topLeft, AlignmentGeometry end = Alignment.bottomRight}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return LinearGradient(
      begin: begin,
      end: end,
      colors: themeProvider.isDarkMode
          ? [
        Color(0xFF022358), // Dark mode gradient start
        Color(0xFF000000), // Dark mode gradient end
      ]
          : [
        Color(0xFFE0E0E0), // Light mode gradient start
        Color(0xFFFFFFFF), // Light mode gradient end
      ],
    );
  }


  static LinearGradient getTreeGradient(BuildContext context, {AlignmentGeometry begin = Alignment.topLeft, AlignmentGeometry end = Alignment.bottomRight}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return LinearGradient(
      begin: begin,
      end: end,
      colors: themeProvider.isDarkMode
          ? [
        Color(0xFF000000), // Début du dégradé en mode sombre
        Color(0xFF022358), // Couleur intermédiaire en mode sombre
        Color(0xFF000000), // Fin du dégradé en mode sombre (exemple)
      ]
          : [
        Color(0xFFFFFFFF), // Début du dégradé en mode clair
        Color(0xFFE0E0E0), // Couleur intermédiaire en mode clair
        Color(0xFFFFFFFF), // Fin du dégradé en mode clair (exemple)
      ],
    );
  }

}