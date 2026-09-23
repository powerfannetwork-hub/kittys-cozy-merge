import 'package:flutter/material.dart';

import '../game/game_screen.dart';

class LevelMapScreen extends StatelessWidget {
  final int unlockedLevel;

  const LevelMapScreen({
    super.key,
    required this.unlockedLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Levels'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 500,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final level = index + 1;

          final unlocked =
              level <= unlockedLevel;

          return GestureDetector(
            onTap: unlocked
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            GameScreen(
                          level: level,
                        ),
                      ),
                    );
                  }
                : null,
            child: Container(
              decoration: BoxDecoration(
                color: unlocked
                    ? Colors.deepPurple
                    : Colors.grey.shade400,
                borderRadius:
                    BorderRadius.circular(18),
              ),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Text(
                    '$level',
                    style:
                        const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Icon(
                    unlocked
                        ? Icons.star
                        : Icons.lock,
                    color: Colors.white,
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
