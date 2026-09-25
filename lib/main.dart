import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/home/home_screen.dart';
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
      home: const HomeScreen(),
    );
  }
}
