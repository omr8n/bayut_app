import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_graduation/core/utils/colors.dart';

class MyThemeData {
  static ThemeData getThemeData({
    required bool isDarkMode,
    required String langCode,
  }) {
    return isDarkMode ? darkTheme(langCode) : lightTheme(langCode);
  }

  static ThemeData lightTheme(String langCode) => ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppColors.background,
    cardColor: AppColors.cardBackground,
    primaryColor: AppColors.primary,
    dividerColor: Colors.grey.withValues(alpha: 0.2),
    brightness: Brightness.light,
    textTheme: langCode == 'ar'
        ? GoogleFonts.cairoTextTheme()
        : GoogleFonts.poppinsTextTheme(),
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      brightness: Brightness.light,
      surface: Colors.white,
    ),
  );

  static ThemeData darkTheme(String langCode) => ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColors.darkBackground,
    cardColor: AppColors.darkCard,
    primaryColor: AppColors.primary,
    dividerColor: AppColors.darkSurface.withValues(alpha: 0.5),
    brightness: Brightness.dark,
    textTheme: langCode == 'ar'
        ? GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme)
        : GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkCard,
      selectedItemColor: Colors.white,
      unselectedItemColor: AppColors.textSecondaryDark,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkInput,
      contentPadding: const EdgeInsets.all(12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.darkCard,
      onSurface: Colors.white,
      brightness: Brightness.dark,
    ),
  );
}
