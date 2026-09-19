import 'package:flutter/material.dart';

class AppTheme {
  static const Color bleuNuit = Color(0xFF252A5A);
  static const Color turquoise = Color(0xFF41B3A3);
  static const Color corail = Color(0xFFFF6B5E);
  static const Color creme = Color(0xFFF6F1EB);
  static const Color texteFonce = Color(0xFF263238);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,

      scaffoldBackgroundColor: creme,

      colorScheme: ColorScheme.fromSeed(
        seedColor: bleuNuit,
        primary: bleuNuit,
        secondary: turquoise,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: bleuNuit,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: corail,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        ),
      ),
    );
  }
}
