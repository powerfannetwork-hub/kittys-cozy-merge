import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // ===== COLORS =====

  static const Color primary = Color(0xFF6C4DFF);
  static const Color secondary = Color(0xFFFFC83D);

  static const Color background = Color(0xFFF4F6FF);

  static const Color card = Colors.white;

  static const Color success = Color(0xFF26C281);

  static const Color danger = Color(0xFFFF5A5F);

  static const Color coin = Color(0xFFFFB800);

  static const Color gem = Color(0xFF00D2FF);

  static const Color life = Color(0xFFFF4F87);

  static const Color textDark = Color(0xFF1D1D1F);

  static const Color textLight = Color(0xFF6E6E73);

  // ===== LIGHT THEME =====

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    scaffoldBackgroundColor: background,

    fontFamily: 'Poppins',

    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: secondary,
      surface: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
    ),

    cardTheme: CardTheme(
      color: card,
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 58),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textDark,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: textDark,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: textDark,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: textLight,
      ),
    ),
  );
}
