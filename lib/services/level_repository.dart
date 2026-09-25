import 'package:flutter/foundation.dart';

import '../models/gem_type.dart';
import '../models/level_config.dart';
import '../models/level_goal.dart';

class LevelRepository {
  LevelRepository._();

  static final LevelRepository instance =
      LevelRepository._();

  static const List<LevelConfig> _levels =
      <LevelConfig>[
    LevelConfig(
      levelNumber: 1,
      rows: 8,
      columns: 8,
      moves: 20,
      goals: <LevelGoal>[
        LevelGoal(
          type: LevelGoalType.collectGem,
          target: 12,
          gemType: GemType.pink,
        ),
        LevelGoal(
          type: LevelGoalType.reachScore,
          target: 500,
        ),
      ],
    ),

    LevelConfig(
      levelNumber: 2,
      rows: 8,
      columns: 8,
      moves: 22,
      goals: <LevelGoal>[
        LevelGoal(
          type: LevelGoalType.collectGem,
          target: 15,
          gemType: GemType.blue,
        ),
        LevelGoal(
          type: LevelGoalType.reachScore,
          target: 650,
        ),
      ],
    ),

    LevelConfig(
      levelNumber: 3,
      rows: 8,
      columns: 8,
      moves: 24,
      goals: <LevelGoal>[
        LevelGoal(
          type: LevelGoalType.collectGem,
          target: 18,
          gemType: GemType.purple,
        ),
        LevelGoal(
          type: LevelGoalType.reachScore,
          target: 800,
        ),
      ],
    ),

    LevelConfig(
      levelNumber: 4,
      rows: 8,
      columns: 8,
      moves: 25,
      goals: <LevelGoal>[
        LevelGoal(
          type: LevelGoalType.collectGem,
          target: 20,
          gemType: GemType.green,
        ),
        LevelGoal(
          type: LevelGoalType.collectGem,
          target: 10,
          gemType: GemType.yellow,
        ),
        LevelGoal(
          type: LevelGoalType.reachScore,
          target: 950,
        ),
      ],
    ),

    LevelConfig(
      levelNumber: 5,
      rows: 8,
      columns: 8,
      moves: 26,
      goals: <LevelGoal>[
        LevelGoal(
          type: LevelGoalType.collectGem,
          target: 22,
          gemType: GemType.orange,
        ),
        LevelGoal(
          type: LevelGoalType.reachScore,
          target: 1100,
        ),
      ],
    ),

    LevelConfig(
      levelNumber: 6,
      rows: 8,
      columns: 8,
      moves: 27,
      goals: <LevelGoal>[
        LevelGoal(
          type: LevelGoalType.collectGem,
          target: 24,
          gemType: GemType.pink,
        ),
        LevelGoal(
          type: LevelGoalType.collectGem,
          target: 12,
          gemType: GemType.blue,
        ),
        LevelGoal(
          type: LevelGoalType.reachScore,
          target: 1250,
        ),
      ],
    ),

    LevelConfig(
      levelNumber: 7,
      rows: 8,
      columns: 8,
      moves: 28,
      goals: <LevelGoal>[
        LevelGoal(
          type: LevelGoalType.collectGem,
          target: 26,
          gemType: GemType.purple,
        ),
        LevelGoal(
          type: LevelGoalType.reachScore,
          target: 1400,
        ),
      ],
    ),

    LevelConfig(
      levelNumber: 8,
      rows: 8,
      columns: 8,
      moves: 30,
      goals: <LevelGoal>[
        LevelGoal(
          type: LevelGoalType.collectGem,
          target: 28,
          gemType: GemType.green,
        ),
        LevelGoal(
          type: LevelGoalType.collectGem,
          target: 14,
          gemType: GemType.orange,
        ),
        LevelGoal(
          type: LevelGoalType.reachScore,
          target: 1550,
        ),
      ],
    ),

    LevelConfig(
      levelNumber: 9,
      rows: 8,
      columns: 8,
      moves: 30,
      goals: <LevelGoal>[
        LevelGoal(
          type: LevelGoalType.collectGem,
          target: 30,
          gemType: GemType.yellow,
        ),
        LevelGoal(
          type: LevelGoalType.collectGem,
          target: 15,
          gemType: GemType.pink,
        ),
        LevelGoal(
          type: LevelGoalType.reachScore,
          target: 1700,
        ),
      ],
    ),

    LevelConfig(
      levelNumber: 10,
      rows: 8,
      columns: 8,
      moves: 32,
      goals: <LevelGoal>[
        LevelGoal(
          type: LevelGoalType.collectGem,
          target: 32,
          gemType: GemType.blue,
        ),
        LevelGoal(
          type: LevelGoalType.collectGem,
          target: 16,
          gemType: GemType.purple,
        ),
        LevelGoal(
          type: LevelGoalType.reachScore,
          target: 1900,
        ),
      ],
    ),
  ];

  List<LevelConfig> get levels {
    return List<LevelConfig>.unmodifiable(
      _levels,
    );
  }

  int get levelCount => _levels.length;

  LevelConfig getLevel(int levelNumber) {
    if (levelNumber <= 0) {
      throw ArgumentError(
        'Level number must be greater than zero.',
      );
    }

    for (final level in _levels) {
      if (level.levelNumber == levelNumber) {
        return level.resetGoalProgress();
      }
    }

    throw RangeError(
      'Level $levelNumber does not exist.',
    );
  }

  bool hasLevel(int levelNumber) {
    if (levelNumber <= 0) {
      return false;
    }

    return _levels.any(
      (level) => level.levelNumber == levelNumber,
    );
  }

  bool hasNextLevel(int levelNumber) {
    return hasLevel(levelNumber + 1);
  }

  LevelConfig? tryGetLevel(int levelNumber) {
    if (!hasLevel(levelNumber)) {
      return null;
    }

    return getLevel(levelNumber);
  }

  LevelConfig? getNextLevel(int levelNumber) {
    return tryGetLevel(levelNumber + 1);
  }

  LevelConfig get firstLevel {
    return getLevel(1);
  }

  @visibleForTesting
  static List<LevelConfig> get testLevels {
    return List<LevelConfig>.unmodifiable(
      _levels,
    );
  }
}
