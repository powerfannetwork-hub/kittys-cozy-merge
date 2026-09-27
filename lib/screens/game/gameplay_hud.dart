import 'package:flutter/material.dart';

import '../../game/gameplay/gameplay_view_controller.dart';

class GameplayHud extends StatelessWidget {
  const GameplayHud({
    super.key,
    required this.controller,
  });

  final GameplayViewController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            4,
            16,
            12,
          ),
          child: Row(
            children: [
              Expanded(
                child: _MovesCard(
                  moves: controller.movesRemaining,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: _GoalsCard(
                  controller: controller,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class GameplayHeader extends StatelessWidget {
  const GameplayHeader({
    super.key,
    required this.controller,
    required this.onBack,
  });

  final GameplayViewController controller;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            10,
            16,
            8,
          ),
          child: Row(
            children: [
              _HeaderButton(
                icon: Icons.arrow_back_rounded,
                onTap: onBack,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LEVEL ${controller.levelNumber}',
                      style: const TextStyle(
                        fontSize: 11,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF9C8792),
                      ),
                    ),
                    const Text(
                      'Cozy Challenge',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF342632),
                      ),
                    ),
                  ],
                ),
              ),
              _ScoreBadge(
                score: controller.score,
              ),
            ],
          ),
        );
      },
    );
  }
}

class GameplayHint extends StatelessWidget {
  const GameplayHint({
    super.key,
    required this.controller,
  });

  final GameplayViewController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            18,
            5,
            18,
            16,
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.swipe_rounded,
                size: 19,
                color: Color(0xFFB18E9E),
              ),
              const SizedBox(width: 7),
              Text(
                controller.isProcessingMove
                    ? 'Matching...'
                    : 'Hold a gem, drag to a neighbor, release',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF9B8792),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MovesCard extends StatelessWidget {
  const _MovesCard({
    required this.moves,
  });

  final int moves;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 67,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            blurRadius: 15,
            offset: Offset(0, 6),
            color: Color(0x10000000),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.directions_run_rounded,
            color: Color(0xFFFF68AA),
            size: 21,
          ),
          const SizedBox(height: 2),
          const Text(
            'MOVES',
            style: TextStyle(
              fontSize: 7,
              fontWeight: FontWeight.w800,
              color: Color(0xFFA18D98),
            ),
          ),
          Text(
            '$moves',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Color(0xFF342632),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalsCard extends StatelessWidget {
  const _GoalsCard({
    required this.controller,
  });

  final GameplayViewController controller;

  @override
  Widget build(BuildContext context) {
    final goals = controller.session.goals;

    return Container(
      height: 67,
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            blurRadius: 15,
            offset: Offset(0, 6),
            color: Color(0x10000000),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.flag_rounded,
            color: Color(0xFFF0B23E),
            size: 21,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              children: List.generate(
                goals.length,
                (index) {
                  final goal = goals[index];

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right:
                            index == goals.length - 1
                                ? 0
                                : 6,
                      ),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            goal.title,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style:
                                const TextStyle(
                              fontSize: 8,
                              fontWeight:
                                  FontWeight.w800,
                              color:
                                  Color(0xFF927E89),
                            ),
                          ),
                          const SizedBox(height: 3),
                          LinearProgressIndicator(
                            value: goal.progress,
                            minHeight: 5,
                            borderRadius:
                                BorderRadius.circular(
                              10,
                            ),
                            backgroundColor:
                                const Color(0xFFF0E9ED),
                            valueColor:
                                const AlwaysStoppedAnimation<
                                    Color>(
                              Color(0xFFFF68AA),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${goal.current}/${goal.target}',
                            style:
                                const TextStyle(
                              fontSize: 8,
                              fontWeight:
                                  FontWeight.w900,
                              color:
                                  Color(0xFF4C3945),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({
    required this.score,
  });

  final int score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            blurRadius: 13,
            offset: Offset(0, 5),
            color: Color(0x10000000),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.star_rounded,
            color: Color(0xFFF1B43B),
            size: 19,
          ),
          const SizedBox(width: 5),
          Text(
            '$score',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: Color(0xFF342632),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: const SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF705C69),
            size: 22,
          ),
        ),
      ),
    );
  }
}
