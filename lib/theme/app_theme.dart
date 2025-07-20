import 'package:flutter/material.dart';

class AppColors {
  static const deepMaroon = Color(0xFF741D1F);
  static const oliveGreen = Color(0xFF637C33);
  static const cream = Color(0xFFF2E3D4);
  static const darkBg = Color(0xFF1E1E1E);
  static const darkCard = Color(0xFF2C2C2C);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.cream,
      fontFamily: 'Roboto',
      colorScheme: ColorScheme.light(
        primary: AppColors.deepMaroon,
        secondary: AppColors.oliveGreen,
        surface: AppColors.cream,
        background: AppColors.cream,
        onPrimary: Colors.white,
        onSurface: Colors.black87,
      ),
      cardColor: AppColors.cream,
      canvasColor: AppColors.cream,
      dialogBackgroundColor: AppColors.cream,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.deepMaroon,
        foregroundColor: Colors.white,
      ),
      hintColor: Colors.black54,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      fontFamily: 'Roboto',
      colorScheme: const ColorScheme.dark().copyWith(
        primary: AppColors.deepMaroon,
        secondary: AppColors.oliveGreen,
        surface: AppColors.darkCard,
        background: AppColors.darkBg,
        onPrimary: Colors.white,
        onSurface: Colors.white70,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.deepMaroon,
        foregroundColor: Colors.white,
      ),
      cardColor: AppColors.darkCard,
      dialogBackgroundColor: AppColors.darkCard,
      canvasColor: AppColors.darkBg,
      hintColor: Colors.white70,
    );
  }
}
