import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const GemClashApp());
}

class GemClashApp extends StatelessWidget {
  const GemClashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const Scaffold(
        body: Center(
          child: Text('Gem Clash'),
        ),
      ),
    );
  }
}
