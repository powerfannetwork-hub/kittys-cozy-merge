import 'package:flutter/foundation.dart';

import 'level_goal.dart';

@immutable
class LevelConfig {
  const LevelConfig({
    required this.levelNumber,
    required this.rows,
    required this.columns,
    required this.moves,
    required this.goals,
  })  : assert(levelNumber > 0),
        assert(rows > 0),
        assert(columns > 0),
        assert(moves > 0),
        assert(goals.isNotEmpty);

  /// The unique level number.
  final int levelNumber;

  /// Number of rows on the board.
  final int rows;

  /// Number of columns on the board.
  final int columns;

  /// Maximum number of moves available.
  final int moves;

  /// Goals required to complete this level.
  final List<LevelGoal> goals;

  /// Total number of goals in this level.
  int get goalCount => goals.length;

  /// Whether every goal in the level is complete.
  bool get isComplete {
    return goals.every(
      (goal) => goal.isComplete,
    );
  }

  /// Number of goals already completed.
  int get completedGoalCount {
    return goals.where(
      (goal) => goal.isComplete,
    ).length;
  }

  /// Whether the level configuration is valid.
  ///
  /// This is separate from constructor assertions so the
  /// configuration can also be validated safely at runtime.
  bool get isValid {
    if (levelNumber <= 0 ||
        rows <= 0 ||
        columns <= 0 ||
        moves <= 0 ||
        goals.isEmpty) {
      return false;
    }

    return goals.every(
      (goal) => goal.isValid,
    );
  }

  /// Returns a copy with optional updated values.
  LevelConfig copyWith({
    int? levelNumber,
    int? rows,
    int? columns,
    int? moves,
    List<LevelGoal>? goals,
  }) {
    return LevelConfig(
      levelNumber:
          levelNumber ?? this.levelNumber,
      rows: rows ?? this.rows,
      columns:
          columns ?? this.columns,
      moves: moves ?? this.moves,
      goals: goals ?? this.goals,
    );
  }

  /// Returns a new configuration with one goal replaced.
  ///
  /// The index must point to an existing goal.
  LevelConfig updateGoal(
    int index,
    LevelGoal goal,
  ) {
    if (index < 0 ||
        index >= goals.length) {
      throw RangeError.index(
        index,
        goals,
        'index',
        'Goal index is outside the level.',
      );
    }

    final updatedGoals =
        List<LevelGoal>.from(goals);

    updatedGoals[index] = goal;

    return copyWith(
      goals: List<LevelGoal>.unmodifiable(
        updatedGoals,
      ),
    );
  }

  /// Returns a new configuration with all goals
  /// replaced by the supplied list.
  LevelConfig withGoals(
    Iterable<LevelGoal> newGoals,
  ) {
    final updatedGoals =
        List<LevelGoal>.unmodifiable(
      newGoals,
    );

    if (updatedGoals.isEmpty) {
      throw ArgumentError(
        'A level must contain at least one goal.',
      );
    }

    return copyWith(
      goals: updatedGoals,
    );
  }

  /// Creates a fresh level configuration where every
  /// goal starts from zero progress.
  LevelConfig resetGoalProgress() {
    final resetGoals =
        goals.map(
      (goal) => goal.setProgress(0),
    );

    return copyWith(
      goals: List<LevelGoal>.unmodifiable(
        resetGoals,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! LevelConfig) {
      return false;
    }

    if (other.levelNumber !=
            levelNumber ||
        other.rows != rows ||
        other.columns != columns ||
        other.moves != moves ||
        other.goals.length !=
            goals.length) {
      return false;
    }

    for (int index = 0;
        index < goals.length;
        index++) {
      if (other.goals[index] !=
          goals[index]) {
        return false;
      }
    }

    return true;
  }

  @override
  int get hashCode {
    return Object.hash(
      levelNumber,
      rows,
      columns,
      moves,
      Object.hashAll(goals),
    );
  }

  @override
  String toString() {
    return 'LevelConfig('
        'levelNumber: $levelNumber, '
        'rows: $rows, '
        'columns: $columns, '
        'moves: $moves, '
        'goals: $goals'
        ')';
  }
}
