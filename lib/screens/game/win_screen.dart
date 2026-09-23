import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'game_screen.dart';

class WinScreen extends StatefulWidget {
  final int level;
  final int score;

  const WinScreen({
    super.key,
    required this.level,
    required this.score,
  });

  @override
  State<WinScreen> createState() => _WinScreenState();
}

class _WinScreenState extends State<WinScreen> {
  bool _saving = true;

  int get targetScore {
    return 500 + ((widget.level - 1) * 50);
  }

  int get stars {
    final percentage =
        widget.score / targetScore;

    if (percentage >= 2.0) {
      return 3;
    }

    if (percentage >= 1.5) {
      return 2;
    }

    return 1;
  }

  @override
  void initState() {
    super.initState();
    _saveProgress();
  }

  Future<void> _saveProgress() async {
    final prefs =
        await SharedPreferences.getInstance();

    // Current unlocked level
    final currentUnlocked =
        prefs.getInt('unlocked_level') ?? 1;

    // Unlock next level
    if (widget.level < 500) {
      final nextLevel =
          widget.level + 1;

      if (nextLevel > currentUnlocked) {
        await prefs.setInt(
          'unlocked_level',
          nextLevel,
        );
      }
    }

    // Save best score
    final oldScore =
        prefs.getInt(
              'level_${widget.level}_score',
            ) ??
            0;

    if (widget.score > oldScore) {
      await prefs.setInt(
        'level_${widget.level}_score',
        widget.score,
      );
    }

    // Save best stars
    final oldStars =
        prefs.getInt(
              'level_${widget.level}_stars',
            ) ??
            0;

    if (stars > oldStars) {
      await prefs.setInt(
        'level_${widget.level}_stars',
        stars,
      );
    }

    if (!mounted) return;

    setState(() {
      _saving = false;
    });
  }

  void _nextLevel() {
    if (widget.level >= 500) {
      Navigator.pop(context);
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          level: widget.level + 1,
        ),
      ),
    );
  }

  void _backToLevels() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isLastLevel =
        widget.level >= 500;

    return Scaffold(
      backgroundColor:
          const Color(0xFF1B1B2F),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Text(
                  isLastLevel ? '🏆' : '🎉',
                  style: const TextStyle(
                    fontSize: 70,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  isLastLevel
                      ? 'ALL LEVELS COMPLETE!'
                      : 'LEVEL COMPLETE!',
                  textAlign:
                      TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Level ${widget.level}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 28),

                // STARS
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) {
                      final earned =
                          index < stars;

                      return Padding(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 5,
                        ),
                        child: Icon(
                          earned
                              ? Icons.star
                              : Icons.star_border,
                          color: earned
                              ? Colors.amber
                              : Colors.white30,
                          size: 55,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 25),

                // SCORE
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.08),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'SCORE',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 13,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        '${widget.score}',
                        style:
                            const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        '$stars / 3 Stars',
                        style:
                            const TextStyle(
                          color: Colors.amber,
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'Target: $targetScore',
                        style:
                            const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // NEXT LEVEL
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: _saving
                        ? null
                        : _nextLevel,
                    child: Text(
                      isLastLevel
                          ? '🏆 FINISH'
                          : 'NEXT LEVEL  →',
                      style:
                          const TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // LEVEL MAP
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed:
                        _saving
                            ? null
                            : _backToLevels,
                    style:
                        OutlinedButton.styleFrom(
                      foregroundColor:
                          Colors.white,
                      side:
                          const BorderSide(
                        color:
                            Colors.white38,
                      ),
                    ),
                    child: const Text(
                      'LEVEL MAP',
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                if (_saving)
                  const Text(
                    'Saving progress...',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  )
                else
                  const Text(
                    '✓ Progress saved',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 12,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
