import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'services/game_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GameStorageService.instance.initialize();

  runApp(const KittysCozyMergeApp());
}

class KittysCozyMergeApp extends StatelessWidget {
  const KittysCozyMergeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Kitty's Cozy Merge",
      theme: AppTheme.light(),
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
