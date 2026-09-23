import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../game/game_screen.dart';

class LevelMapScreen extends StatefulWidget {
  const LevelMapScreen({super.key});

  @override
  State<LevelMapScreen> createState() =>
      _LevelMapScreenState();
}

class _LevelMapScreenState
    extends State<LevelMapScreen> {
  int unlockedLevel = 1;

  final Map<int, int> stars = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs =
        await SharedPreferences.getInstance();

    unlockedLevel =
        prefs.getInt('unlocked_level') ?? 1;

    stars.clear();

    for (int i = 1; i <= 500; i++) {
      stars[i] =
          prefs.getInt('level_${i}_stars') ??
              0;
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _openLevel(
    int level,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            GameScreen(level: level),
      ),
    );

    _loadProgress();
  }

  Widget _buildStars(
    int count,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) => Icon(
          index < count
              ? Icons.star
              : Icons.star_border,
          color: Colors.amber,
          size: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Level Map'),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding:
            const EdgeInsets.all(16),
        itemCount: 500,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder:
            (context, index) {
          final level = index + 1;

          final unlocked =
              level <= unlockedLevel;

          final starCount =
              stars[level] ?? 0;

          return GestureDetector(
            onTap: unlocked
                ? () => _openLevel(
                    level)
                : null,
            child: Container(
              decoration: BoxDecoration(
                color: unlocked
                    ? Colors.deepPurple
                    : Colors.grey,
                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
              ),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment
                        .center,
                children: [
                  Text(
                    '$level',
                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  unlocked
                      ? _buildStars(
                          starCount)
                      : const Icon(
                          Icons.lock,
                          color:
                              Colors.white,
                          size: 18,
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
