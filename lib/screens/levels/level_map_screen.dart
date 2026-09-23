import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_theme.dart';
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

    final savedUnlocked =
        prefs.getInt('unlocked_level') ?? 1;

    final savedStars = <int, int>{};

    for (int i = 1; i <= 500; i++) {
      savedStars[i] =
          prefs.getInt('level_${i}_stars') ?? 0;
    }

    if (!mounted) return;

    setState(() {
      unlockedLevel = savedUnlocked;
      stars
        ..clear()
        ..addAll(savedStars);
    });
  }

  Future<void> _openLevel(int level) async {
    if (level > unlockedLevel) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          level: level,
        ),
      ),
    );

    await _loadProgress();
  }

  Widget _buildStars(int count) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) {
          final earned = index < count;

          return Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 1,
            ),
            child: Icon(
              earned
                  ? Icons.star
                  : Icons.star_border,
              color: earned
                  ? Colors.amber
                  : Colors.white38,
              size: 14,
            ),
          );
        },
      ),
    );
  }

  Color _levelColor(
    int level,
    bool unlocked,
  ) {
    if (!unlocked) {
      return Colors.grey.shade700;
    }

    if (level == unlockedLevel) {
      return AppTheme.primary;
    }

    return const Color(0xFF5E35B1);
  }

  String _levelSubtitle(int level) {
    if (level % 30 == 0) {
      return 'NEW';
    }

    if (level > 1 &&
        level % 10 == 0) {
      return 'CHALLENGE';
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F3FC),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'LEVEL MAP',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(
              right: 16,
            ),
            child: Center(
              child: Text(
                '$unlockedLevel/500',
                style: const TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            margin:
                const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              12,
            ),
            padding:
                const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient:
                  const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primary,
                  Color(0xFF8E6BFF),
                ],
              ),
              borderRadius:
                  BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary
                      .withOpacity(0.25),
                  blurRadius: 18,
                  offset:
                      const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration:
                      BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    color: Colors.amber,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      const Text(
                        'Your Journey',
                        style: TextStyle(
                          color:
                              Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        'Level $unlockedLevel Unlocked',
                        style:
                            const TextStyle(
                          color:
                              Colors.white,
                          fontSize: 21,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white70,
                  size: 16,
                ),
              ],
            ),
          ),

          // MAP
          Expanded(
            child: GridView.builder(
              padding:
                  const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                30,
              ),
              itemCount: 500,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.90,
              ),
              itemBuilder:
                  (context, index) {
                final level = index + 1;

                final unlocked =
                    level <=
                        unlockedLevel;

                final starCount =
                    stars[level] ?? 0;

                final subtitle =
                    _levelSubtitle(level);

                final isCurrent =
                    level ==
                        unlockedLevel;

                return GestureDetector(
                  onTap: unlocked
                      ? () =>
                          _openLevel(level)
                      : null,
                  child: AnimatedContainer(
                    duration:
                        const Duration(
                      milliseconds: 180,
                    ),
                    decoration:
                        BoxDecoration(
                      gradient: unlocked
                          ? LinearGradient(
                              begin:
                                  Alignment
                                      .topLeft,
                              end:
                                  Alignment
                                      .bottomRight,
                              colors: [
                                _levelColor(
                                  level,
                                  unlocked,
                                ),
                                _levelColor(
                                  level,
                                  unlocked,
                                ).withOpacity(
                                  0.72,
                                ),
                              ],
                            )
                          : null,
                      color: unlocked
                          ? null
                          : Colors
                              .grey
                              .shade300,
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                      border: isCurrent
                          ? Border.all(
                              color:
                                  Colors.amber,
                              width: 2,
                            )
                          : null,
                      boxShadow: unlocked
                          ? [
                              BoxShadow(
                                color:
                                    Colors.black
                                        .withOpacity(
                                  0.10,
                                ),
                                blurRadius:
                                    8,
                                offset:
                                    const Offset(
                                  0,
                                  4,
                                ),
                              ),
                            ]
                          : null,
                    ),
                    child: Stack(
                      children: [
                        // LEVEL NUMBER
                        Center(
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,
                            children: [
                              if (!unlocked)
                                const Icon(
                                  Icons.lock,
                                  color:
                                      Colors
                                          .white,
                                  size: 21,
                                )
                              else
                                Text(
                                  '$level',
                                  style:
                                      const TextStyle(
                                    color:
                                        Colors
                                            .white,
                                    fontSize: 23,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),

                              const SizedBox(
                                height: 4,
                              ),

                              if (unlocked)
                                _buildStars(
                                  starCount,
                                ),
                            ],
                          ),
                        ),

                        // CURRENT LEVEL
                        if (isCurrent)
                          Positioned(
                            top: 6,
                            left: 0,
                            right: 0,
                            child: Center(
                              child:
                                  Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal:
                                      8,
                                  vertical:
                                      3,
                                ),
                                decoration:
                                    BoxDecoration(
                                  color:
                                      Colors
                                          .amber,
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    20,
                                  ),
                                ),
                                child:
                                    const Text(
                                  'CURRENT',
                                  style:
                                      TextStyle(
                                    fontSize:
                                        8,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                    color:
                                        Colors
                                            .black87,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // NEW / CHALLENGE
                        if (unlocked &&
                            subtitle.isNotEmpty)
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal:
                                    5,
                                vertical:
                                    3,
                              ),
                              decoration:
                                  BoxDecoration(
                                color: Colors
                                    .orange
                                    .shade700,
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  8,
                                ),
                              ),
                              child: Text(
                                subtitle,
                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white,
                                  fontSize: 7,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
