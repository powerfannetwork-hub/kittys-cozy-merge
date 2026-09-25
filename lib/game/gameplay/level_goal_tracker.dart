import 'package:flutter/foundation.dart';

import '../../models/gem_type.dart';
import '../../models/level_config.dart';
import '../../models/level_goal.dart';

class LevelGoalTracker {
  LevelGoalTracker({
    required LevelConfig level,
  })  : _level = level,
        _goals = List<LevelGoal>.from(level.goals) {
    if (!level.isValid) {
      throw ArgumentError(
        'The supplied level configuration is invalid.',
      );
    }
  }

  final LevelConfig _level;

  final List<LevelGoal> _goals;

  LevelConfig get level => _level;

  List<LevelGoal> get goals =>
      List<LevelGoal>.unmodifiable(_goals);

  int get goalCount => _goals.length;

  int get completedGoalCount {
    return _goals.where(
      (goal) => goal.isComplete,
    ).length;
  }

  bool get isComplete {
    return _goals.every(
      (goal) => goal.isComplete,
    );
  }

  bool get isIncomplete => !isComplete;

  double get overallProgress {
    if (_goals.isEmpty) {
      return 1.0;
    }

    double total = 0.0;

    for (final goal in _goals) {
      total += goal.progress;
    }

    return total / _goals.length;
  }

  LevelGoal goalAt(int index) {
    if (index < 0 || index >= _goals.length) {
      throw RangeError.index(
        index,
        _goals,
        'index',
        'Goal index is outside the level.',
      );
    }

    return _goals[index];
  }

  LevelGoal? goalForType(
    LevelGoalType type, {
    GemType? gemType,
  }) {
    for (final goal in _goals) {
      if (goal.type != type) {
        continue;
      }

      if (type == LevelGoalType.collectGem &&
          goal.gemType != gemType) {
        continue;
      }

      return goal;
    }

    return null;
  }

  void collectGems({
    required GemType gemType,
    required int amount,
  }) {
    if (amount <= 0) {
      return;
    }

    _updateGoals(
      (goal) {
        if (goal.type !=
            LevelGoalType.collectGem) {
          return goal;
        }

        if (goal.gemType != gemType) {
          return goal;
        }

        return goal.addProgress(amount);
      },
    );
  }

  void breakIce(int amount) {
    if (amount <= 0) {
      return;
    }

    _updateGoals(
      (goal) {
        if (goal.type !=
            LevelGoalType.breakIce) {
          return goal;
        }

        return goal.addProgress(amount);
      },
    );
  }

  void breakBlocks(int amount) {
    if (amount <= 0) {
      return;
    }

    _updateGoals(
      (goal) {
        if (goal.type !=
            LevelGoalType.breakBlock) {
          return goal;
        }

        return goal.addProgress(amount);
      },
    );
  }

  void unlockTiles(int amount) {
    if (amount <= 0) {
      return;
    }

    _updateGoals(
      (goal) {
        if (goal.type !=
            LevelGoalType.unlockTile) {
          return goal;
        }

        return goal.addProgress(amount);
      },
    );
  }

  void addScore(int amount) {
    if (amount <= 0) {
      return;
    }

    _updateGoals(
      (goal) {
        if (goal.type !=
            LevelGoalType.reachScore) {
          return goal;
        }

        return goal.addProgress(amount);
      },
    );
  }

  void reset() {
    for (int index = 0;
        index < _goals.length;
        index++) {
      _goals[index] =
          _goals[index].setProgress(0);
    }
  }

  void _updateGoals(
    LevelGoal Function(LevelGoal goal)
        updater,
  ) {
    for (int index = 0;
        index < _goals.length;
        index++) {
      _goals[index] =
          updater(_goals[index]);
    }
  }

  @override
  String toString() {
    return 'LevelGoalTracker('
        'level: ${_level.levelNumber}, '
        'completed: $completedGoalCount/'
        '$goalCount, '
        'progress: $overallProgress'
        ')';
  }
}
