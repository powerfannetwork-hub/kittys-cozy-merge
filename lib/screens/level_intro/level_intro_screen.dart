import 'package:flutter/material.dart';

import '../../models/gem_type.dart';
import '../../models/level_config.dart';
import '../../models/level_goal.dart';
import '../game/game_screen.dart';

class LevelIntroScreen extends StatelessWidget {
  const LevelIntroScreen({
    super.key,
    required this.level,
  });

  final LevelConfig level;

  void _startLevel(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => GameScreen(
          levelNumber: level.levelNumber,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FB),
      body: SafeArea(
        child: Stack(
          children: [
            const _IntroBackground(),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                30,
              ),
              child: Column(
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 18),
                  _buildLevelHero(),
                  const SizedBox(height: 18),
                  _buildStats(),
                  const SizedBox(height: 20),
                  _buildGoalsCard(),
                  const SizedBox(height: 24),
                  _buildStartButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        _RoundButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => Navigator.of(context).pop(),
        ),
        const Spacer(),
        const Text(
          'LEVEL INTRO',
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 1.6,
            fontWeight: FontWeight.w900,
            color: Color(0xFF9B8290),
          ),
        ),
        const Spacer(),
        const SizedBox(width: 46),
      ],
    );
  }

  Widget _buildLevelHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        24,
        27,
        24,
        26,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFC8E2),
            Color(0xFFFFA1C9),
            Color(0xFFE3B1FF),
          ],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            blurRadius: 25,
            offset: Offset(0, 12),
            color: Color(0x1D000000),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.72),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.pets_rounded,
              color: Color(0xFFD36C9D),
              size: 51,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'LEVEL ${level.levelNumber}',
            style: const TextStyle(
              fontSize: 29,
              fontWeight: FontWeight.w900,
              color: Color(0xFF3B2735),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'A new cozy challenge awaits!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF704E60),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.directions_run_rounded,
            title: 'MOVES',
            value: '${level.moves}',
            color: const Color(0xFFFF68AA),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.grid_view_rounded,
            title: 'BOARD',
            value: '${level.rows} × ${level.columns}',
            color: const Color(0xFF8D72FF),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.flag_rounded,
            title: 'GOALS',
            value: '${level.goalCount}',
            color: const Color(0xFFF0B23E),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(27),
        boxShadow: const [
          BoxShadow(
            blurRadius: 20,
            offset: Offset(0, 8),
            color: Color(0x12000000),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.flag_rounded,
                color: Color(0xFFFF68AA),
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'Level Goals',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF342632),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...List.generate(
            level.goals.length,
            (index) => Padding(
              padding: EdgeInsets.only(
                bottom:
                    index == level.goals.length - 1
                        ? 0
                        : 10,
              ),
              child: _GoalPreview(
                goal: level.goals[index],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 62,
      child: ElevatedButton(
        onPressed: () => _startLevel(context),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFFFF68AA),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(21),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.play_arrow_rounded,
              size: 29,
            ),
            SizedBox(width: 8),
            Text(
              'START LEVEL',
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 1.1,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalPreview extends StatelessWidget {
  const _GoalPreview({
    required this.goal,
  });

  final LevelGoal goal;

  @override
  Widget build(BuildContext context) {
    final isGemGoal =
        goal.type == LevelGoalType.collectGem;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8FC),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          _GoalIcon(
            goal: goal,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  goal.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF45323E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isGemGoal && goal.gemType != null
                      ? '${_gemName(goal.gemType!)} × ${goal.target}'
                      : 'Target × ${goal.target}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9B8792),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${goal.target}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Color(0xFFFF68AA),
            ),
          ),
        ],
      ),
    );
  }

  static String _gemName(GemType type) {
    switch (type) {
      case GemType.pink:
        return 'Pink Gems';
      case GemType.blue:
        return 'Blue Gems';
      case GemType.purple:
        return 'Purple Gems';
      case GemType.green:
        return 'Green Gems';
      case GemType.yellow:
        return 'Yellow Gems';
      case GemType.orange:
        return 'Orange Gems';
    }
  }
}

class _GoalIcon extends StatelessWidget {
  const _GoalIcon({
    required this.goal,
  });

  final LevelGoal goal;

  @override
  Widget build(BuildContext context) {
    if (goal.type == LevelGoalType.collectGem &&
        goal.gemType != null) {
      return _MiniGem(
        type: goal.gemType!,
      );
    }

    IconData icon;

    switch (goal.type) {
      case LevelGoalType.collectGem:
        icon = Icons.diamond_rounded;
        break;
      case LevelGoalType.breakIce:
        icon = Icons.ac_unit_rounded;
        break;
      case LevelGoalType.breakBlock:
        icon = Icons.grid_4x4_rounded;
        break;
      case LevelGoalType.unlockTile:
        icon = Icons.lock_open_rounded;
        break;
      case LevelGoalType.reachScore:
        icon = Icons.star_rounded;
        break;
    }

    return Container(
      width: 42,
      height: 42,
      decoration: const BoxDecoration(
        color: Color(0xFFF2EAFE),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: const Color(0xFF8D72FF),
        size: 22,
      ),
    );
  }
}

class _MiniGem extends StatelessWidget {
  const _MiniGem({
    required this.type,
  });

  final GemType type;

  @override
  Widget build(BuildContext context) {
    final colors = _colors(type);

    return Container(
      width: 42,
      height: 42,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 7,
            offset: Offset(0, 3),
            color: Color(0x18000000),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white.withOpacity(0.7),
            width: 1.2,
          ),
        ),
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: 7,
            height: 7,
            margin: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  static List<Color> _colors(GemType type) {
    switch (type) {
      case GemType.pink:
        return const [
          Color(0xFFFFB8D8),
          Color(0xFFFF4F9A),
        ];
      case GemType.blue:
        return const [
          Color(0xFF9DE7FF),
          Color(0xFF3B9DFF),
        ];
      case GemType.purple:
        return const [
          Color(0xFFD5B8FF),
          Color(0xFF8552E8),
        ];
      case GemType.green:
        return const [
          Color(0xFFA9F2C2),
          Color(0xFF39B96B),
        ];
      case GemType.yellow:
        return const [
          Color(0xFFFFF0A1),
          Color(0xFFFFC72C),
        ];
      case GemType.orange:
        return const [
          Color(0xFFFFD0A0),
          Color(0xFFFF823E),
        ];
    }
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 8,
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
        children: [
          Icon(
            icon,
            color: color,
            size: 23,
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              fontSize: 8,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w800,
              color: Color(0xFFA18D98),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Color(0xFF342632),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
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
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(
            icon,
            color: const Color(0xFF705C69),
            size: 23,
          ),
        ),
      ),
    );
  }
}

class _IntroBackground extends StatelessWidget {
  const _IntroBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -90,
            left: -80,
            child: Container(
              width: 220,
              height: 220,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x16FF79B4),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -80,
            child: Container(
              width: 230,
              height: 230,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x128D72FF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
