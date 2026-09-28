import 'package:flutter/foundation.dart';

import '../game/gameplay/level_difficulty_system.dart';
import '../models/gem_type.dart';
import '../models/level_config.dart';
import '../models/level_goal.dart';

class LevelRepository {
  LevelRepository._();

  static final LevelRepository instance =
      LevelRepository._();

  static const int _firstGeneratedLevel = 11;

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

  late final List<LevelConfig> _generatedLevels =
      List<LevelConfig>.generate(
    LevelDifficultySystem.maximumLevel -
        _firstGeneratedLevel +
        1,
    (index) {
      final levelNumber =
          _firstGeneratedLevel + index;

      return _generateLevel(levelNumber);
    },
    growable: false,
  );

  List<LevelConfig> get levels {
    return List<LevelConfig>.unmodifiable(
      <LevelConfig>[
        ..._levels,
        ..._generatedLevels,
      ],
    );
  }

  int get levelCount =>
      LevelDifficultySystem.maximumLevel;

  LevelConfig getLevel(int levelNumber) {
    if (levelNumber <= 0) {
      throw ArgumentError(
        'Level number must be greater than zero.',
      );
    }

    if (levelNumber <= _levels.length) {
      return _levels[levelNumber - 1]
          .resetGoalProgress();
    }

    if (levelNumber >
        LevelDifficultySystem.maximumLevel) {
      throw RangeError(
        'Level $levelNumber does not exist. '
        'Maximum level is '
        '${LevelDifficultySystem.maximumLevel}.',
      );
    }

    return _generatedLevels[levelNumber -
            _firstGeneratedLevel]
        .resetGoalProgress();
  }

  bool hasLevel(int levelNumber) {
    return levelNumber >=
            LevelDifficultySystem.minimumLevel &&
        levelNumber <=
            LevelDifficultySystem.maximumLevel;
  }

  bool hasNextLevel(int levelNumber) {
    if (!hasLevel(levelNumber)) {
      return false;
    }

    return levelNumber <
        LevelDifficultySystem.maximumLevel;
  }

  LevelConfig? tryGetLevel(int levelNumber) {
    if (!hasLevel(levelNumber)) {
      return null;
    }

    return getLevel(levelNumber);
  }

  LevelConfig? getNextLevel(int levelNumber) {
    if (!hasNextLevel(levelNumber)) {
      return null;
    }

    return getLevel(levelNumber + 1);
  }

  LevelConfig get firstLevel {
    return getLevel(
      LevelDifficultySystem.minimumLevel,
    );
  }

  LevelConfig _generateLevel(int levelNumber) {
    final profile =
        LevelDifficultySystem.profileFor(
      levelNumber,
    );

    final goals =
        _generateGoals(
      levelNumber,
      profile,
    );

    return LevelConfig(
      levelNumber: levelNumber,
      rows: 8,
      columns: 8,
      moves: profile.moves,
      goals: List<LevelGoal>.unmodifiable(
        goals,
      ),
    );
  }

  List<LevelGoal> _generateGoals(
    int levelNumber,
    LevelDifficultyProfile profile,
  ) {
    final goals = <LevelGoal>[];

    final primaryGem =
        _gemTypeForLevel(levelNumber);

    final secondaryGem =
        _secondaryGemTypeForLevel(
      levelNumber,
      primaryGem,
    );

    final primaryTarget =
        _primaryGemTarget(
      levelNumber,
      profile,
    );

    final secondaryTarget =
        _secondaryGemTarget(
      levelNumber,
      profile,
    );

    goals.add(
      LevelGoal(
        type: LevelGoalType.collectGem,
        target: primaryTarget,
        gemType: primaryGem,
      ),
    );

    if (profile.maxGoals >= 3) {
      goals.add(
        LevelGoal(
          type: LevelGoalType.collectGem,
          target: secondaryTarget,
          gemType: secondaryGem,
        ),
      );
    }

    if (profile.maxGoals >= 4) {
      goals.add(
        LevelGoal(
          type: LevelGoalType.reachScore,
          target: _scoreTarget(
            levelNumber,
            profile,
          ),
        ),
      );
    }

    if (profile.maxGoals >= 5) {
      goals.add(
        LevelGoal(
          type: LevelGoalType.collectGem,
          target: _bonusGemTarget(
            levelNumber,
            profile,
          ),
          gemType:
              _bonusGemTypeForLevel(
            levelNumber,
            primaryGem,
            secondaryGem,
          ),
        ),
      );
    }

    if (goals.length >
        profile.maxGoals) {
      return goals.sublist(
        0,
        profile.maxGoals,
      );
    }

    return goals;
  }

  GemType _gemTypeForLevel(
    int levelNumber,
  ) {
    const types = <GemType>[
      GemType.pink,
      GemType.blue,
      GemType.purple,
      GemType.green,
      GemType.yellow,
      GemType.orange,
    ];

    return types[
      (levelNumber - 1) % types.length
    ];
  }

  GemType _secondaryGemTypeForLevel(
    int levelNumber,
    GemType primary,
  ) {
    const types = <GemType>[
      GemType.pink,
      GemType.blue,
      GemType.purple,
      GemType.green,
      GemType.yellow,
      GemType.orange,
    ];

    final primaryIndex =
        types.indexOf(primary);

    return types[
      (primaryIndex +
              2 +
              (levelNumber ~/ 100)) %
          types.length
    ];
  }

  GemType _bonusGemTypeForLevel(
    int levelNumber,
    GemType primary,
    GemType secondary,
  ) {
    const types = <GemType>[
      GemType.pink,
      GemType.blue,
      GemType.purple,
      GemType.green,
      GemType.yellow,
      GemType.orange,
    ];

    for (int offset = 1;
        offset <= types.length;
        offset++) {
      final candidate =
          types[
            (levelNumber + offset) %
                types.length
          ];

      if (candidate != primary &&
          candidate != secondary) {
        return candidate;
      }
    }

    return GemType.orange;
  }

  int _primaryGemTarget(
    int levelNumber,
    LevelDifficultyProfile profile,
  ) {
    final base =
        18 + (levelNumber ~/ 100);

    final difficultyBonus =
        profile.tier.index * 2;

    final specialBonus =
        profile.isSpecialLevel ? 4 : 0;

    return base +
        difficultyBonus +
        specialBonus;
  }

  int _secondaryGemTarget(
    int levelNumber,
    LevelDifficultyProfile profile,
  ) {
    final base =
        8 + (levelNumber ~/ 250);

    final difficultyBonus =
        profile.tier.index;

    final specialBonus =
        profile.isSpecialLevel ? 2 : 0;

    return base +
        difficultyBonus +
        specialBonus;
  }

  int _bonusGemTarget(
    int levelNumber,
    LevelDifficultyProfile profile,
  ) {
    final base =
        6 + (levelNumber ~/ 500);

    final difficultyBonus =
        profile.tier.index;

    return base + difficultyBonus;
  }

  int _scoreTarget(
    int levelNumber,
    LevelDifficultyProfile profile,
  ) {
    final base =
        1200 + (levelNumber * 90);

    final difficultyMultiplier =
        1 + (profile.tier.index * 0.08);

    final specialBonus =
        profile.isSpecialLevel
            ? 500
            : 0;

    return (base * difficultyMultiplier).round() +
        specialBonus;
  }

  @visibleForTesting
  static List<LevelConfig> get testLevels {
    return List<LevelConfig>.unmodifiable(
      _levels,
    );
  }
}
