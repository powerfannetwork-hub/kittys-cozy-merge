import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFFFF8FC),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFF78B7),
        brightness: Brightness.light,
      ),
      fontFamily: 'sans-serif',
    );
  }
}
