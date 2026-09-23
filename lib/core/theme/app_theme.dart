import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

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

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: background,

    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: secondary,
    ),
  );
}
