import 'package:flutter/material.dart';

import '../../models/level_config.dart';
import '../../services/game_storage_service.dart';
import '../../services/level_repository.dart';
import '../level_intro/level_intro_screen.dart';

class LevelMapScreen extends StatefulWidget {
  const LevelMapScreen({super.key});

  @override
  State<LevelMapScreen> createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen> {
  final LevelRepository _repository =
      LevelRepository.instance;

  final GameStorageService _storage =
      GameStorageService.instance;

  int get _currentLevel => _storage.currentLevel;

  void _openLevel(LevelConfig level) {
    final unlocked = level.levelNumber <= _currentLevel;

    if (!unlocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Complete Level ${level.levelNumber - 1} to unlock this level.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => LevelIntroScreen(
          level: level,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final levels = _repository.levels;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildProgressHeader(),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  22,
                  10,
                  22,
                  35,
                ),
                itemCount: levels.length,
                itemBuilder: (context, index) {
                  final level = levels[index];

                  return _LevelMapItem(
                    level: level,
                    currentLevel: _currentLevel,
                    isLast: index == levels.length - 1,
                    onTap: () => _openLevel(level),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        12,
        18,
        10,
      ),
      child: Row(
        children: [
          _HeaderButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Adventure',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF9B8591),
                  ),
                ),
                Text(
                  'Cozy Map',
                  style: TextStyle(
                    fontSize: 23,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF342632),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 14,
                  offset: Offset(0, 6),
                  color: Color(0x12000000),
                ),
              ],
            ),
            child: const Icon(
              Icons.pets_rounded,
              color: Color(0xFFFF68AA),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressHeader() {
    final completed =
        (_currentLevel - 1).clamp(0, _repository.levelCount);

    final progress =
        _repository.levelCount == 0
            ? 0.0
            : completed / _repository.levelCount;

    return Container(
      margin: const EdgeInsets.fromLTRB(18, 4, 18, 12),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFD3E7),
            Color(0xFFEBC9FF),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            blurRadius: 18,
            offset: Offset(0, 8),
            color: Color(0x16000000),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.72),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.explore_rounded,
                  color: Color(0xFFB44C87),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Cozy Journey',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF4C3042),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Keep matching to discover new places.',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7E5B6C),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$_currentLevel/${_repository.levelCount}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF7B3F68),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.55),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFFF68AA),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelMapItem extends StatelessWidget {
  const _LevelMapItem({
    required this.level,
    required this.currentLevel,
    required this.isLast,
    required this.onTap,
  });

  final LevelConfig level;
  final int currentLevel;
  final bool isLast;
  final VoidCallback onTap;

  bool get isUnlocked =>
      level.levelNumber <= currentLevel;

  bool get isCurrent =>
      level.levelNumber == currentLevel;

  bool get isCompleted =>
      level.levelNumber < currentLevel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 128,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 82,
            child: Column(
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: _LevelNode(
                    levelNumber: level.levelNumber,
                    unlocked: isUnlocked,
                    current: isCurrent,
                    completed: isCompleted,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 4,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? const Color(0xFFFF91BD)
                              : const Color(0xFFE8DCE3),
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: GestureDetector(
                onTap: onTap,
                child: _LevelInfoCard(
                  level: level,
                  unlocked: isUnlocked,
                  current: isCurrent,
                  completed: isCompleted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelNode extends StatelessWidget {
  const _LevelNode({
    required this.levelNumber,
    required this.unlocked,
    required this.current,
    required this.completed,
  });

  final int levelNumber;
  final bool unlocked;
  final bool current;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    final Color background;

    if (completed) {
      background = const Color(0xFFFF78B3);
    } else if (current) {
      background = const Color(0xFF8D72FF);
    } else if (unlocked) {
      background = const Color(0xFFFFA2C8);
    } else {
      background = const Color(0xFFD9CED5);
    }

    return Container(
      width: 67,
      height: 67,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: background,
        boxShadow: [
          BoxShadow(
            blurRadius: current ? 18 : 10,
            offset: const Offset(0, 6),
            color: current
                ? const Color(0x328D72FF)
                : const Color(0x14000000),
          ),
        ],
      ),
      child: Center(
        child: completed
            ? const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 31,
              )
            : unlocked
                ? Text(
                    '$levelNumber',
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  )
                : const Icon(
                    Icons.lock_rounded,
                    color: Colors.white,
                    size: 25,
                  ),
      ),
    );
  }
}

class _LevelInfoCard extends StatelessWidget {
  const _LevelInfoCard({
    required this.level,
    required this.unlocked,
    required this.current,
    required this.completed,
  });

  final LevelConfig level;
  final bool unlocked;
  final bool current;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        15,
        13,
        13,
        13,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: current
            ? Border.all(
                color: const Color(0xFFFF9BC5),
                width: 1.5,
              )
            : null,
        boxShadow: const [
          BoxShadow(
            blurRadius: 16,
            offset: Offset(0, 6),
            color: Color(0x0F000000),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Level ${level.levelNumber}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF342632),
                      ),
                    ),
                    if (current) ...[
                      const SizedBox(width: 7),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEEF6),
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'NEXT',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFFF5FA6),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.directions_run_rounded,
                      size: 15,
                      color: Color(0xFF9B8591),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${level.moves} moves',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF9B8591),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.flag_rounded,
                      size: 14,
                      color: Color(0xFF9B8591),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${level.goalCount} goals',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF9B8591),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: unlocked
                  ? const Color(0xFFFFEEF6)
                  : const Color(0xFFF3EEF1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              completed
                  ? Icons.check_rounded
                  : unlocked
                      ? Icons.arrow_forward_rounded
                      : Icons.lock_rounded,
              color: unlocked
                  ? const Color(0xFFFF68AA)
                  : const Color(0xFFB8AAB2),
              size: 21,
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
