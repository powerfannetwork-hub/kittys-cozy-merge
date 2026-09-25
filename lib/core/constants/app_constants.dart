import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const KittysCozyMergeApp());
}

class KittysCozyMergeApp extends StatelessWidget {
  const KittysCozyMergeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Kitty's Cozy Merge",
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFFF8FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF78B7),
          brightness: Brightness.light,
        ),
      ),
      home: const AppPlaceholder(),
    );
  }
}

class AppPlaceholder extends StatelessWidget {
  const AppPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Kitty's Cozy Merge",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
