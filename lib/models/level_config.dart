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
        assert(moves > 0);

  final int levelNumber;
  final int rows;
  final int columns;
  final int moves;
  final List<LevelGoal> goals;

  int get goalCount => goals.length;

  bool get isComplete => goals.every(
        (goal) => goal.isComplete,
      );

  int get completedGoalCount =>
      goals.where(
        (goal) => goal.isComplete,
      ).length;

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

  LevelConfig copyWith({
    int? levelNumber,
    int? rows,
    int? columns,
    int? moves,
    List<LevelGoal>? goals,
  }) {
    return LevelConfig(
      levelNumber: levelNumber ?? this.levelNumber,
      rows: rows ?? this.rows,
      columns: columns ?? this.columns,
      moves: moves ?? this.moves,
      goals: goals ?? this.goals,
    );
  }

  LevelConfig updateGoal(
    int index,
    LevelGoal goal,
  ) {
    if (index < 0 || index >= goals.length) {
      throw RangeError.index(
        index,
        goals,
        'index',
        'Goal index is outside the level.',
      );
    }

    final updatedGoals = List<LevelGoal>.from(goals);

    updatedGoals[index] = goal;

    return copyWith(
      goals: List<LevelGoal>.unmodifiable(
        updatedGoals,
      ),
    );
  }

  LevelConfig withGoals(
    Iterable<LevelGoal> newGoals,
  ) {
    final updatedGoals = List<LevelGoal>.unmodifiable(
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

  LevelConfig resetGoalProgress() {
    final resetGoals = goals.map(
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

    if (other.levelNumber != levelNumber ||
        other.rows != rows ||
        other.columns != columns ||
        other.moves != moves ||
        other.goals.length != goals.length) {
      return false;
    }

    for (int index = 0;
        index < goals.length;
        index++) {
      if (other.goals[index] != goals[index]) {
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
