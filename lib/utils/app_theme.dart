import 'package:flutter/material.dart';
import 'colors.dart'; // Ensure this is the correct path to your AppColors

class AppTheme {
  static ThemeData getLightTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.getPrimaryColor(context),
      scaffoldBackgroundColor: AppColors.getBackgroundColor(context),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: AppColors.getTextColor(context)),
        bodyMedium: TextStyle(color: AppColors.getTextColor(context)),
      ),
      appBarTheme: AppBarTheme(
        color: AppColors.getPrimaryColor(context),
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: AppColors.getTextColor(context)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.getAccentColor(context)),
        ),
      ),
      colorScheme: ColorScheme.light(
        primary: AppColors.getPrimaryColor(context),
        secondary: AppColors.getSecondaryColor(context),
        background: AppColors.getBackgroundColor(context),
        error: AppColors.getErrorColor(context),
      ),
    );
  }

  static ThemeData getDarkTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.getPrimaryColor(context),
      scaffoldBackgroundColor: AppColors.getBackgroundColor(context),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: AppColors.getTextColor(context)),
        bodyMedium: TextStyle(color: AppColors.getTextColor(context)),
      ),
      appBarTheme: AppBarTheme(
        color: AppColors.getPrimaryColor(context),
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: AppColors.getTextColor(context)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.getAccentColor(context)),
        ),
      ),
      colorScheme: ColorScheme.dark(
        primary: AppColors.getPrimaryColor(context),
        secondary: AppColors.getSecondaryColor(context),
        background: AppColors.getBackgroundColor(context),
        error: AppColors.getErrorColor(context),
      ),
    );
  }
}