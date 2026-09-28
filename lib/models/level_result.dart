import 'package:flutter/foundation.dart';

enum LevelResultType {
  completed,
  failed,
}

@immutable
class LevelResult {
  const LevelResult({
    required this.levelNumber,
    required this.type,
    required this.score,
    required this.movesUsed,
    required this.movesRemaining,
    required this.completedGoals,
    required this.totalGoals,
    required this.stars,
  })  : assert(levelNumber > 0),
        assert(score >= 0),
        assert(movesUsed >= 0),
        assert(movesRemaining >= 0),
        assert(completedGoals >= 0),
        assert(totalGoals >= 0),
        assert(completedGoals <= totalGoals),
        assert(stars >= 0),
        assert(stars <= 3);

  final int levelNumber;
  final LevelResultType type;

  final int score;

  final int movesUsed;
  final int movesRemaining;

  final int completedGoals;
  final int totalGoals;

  final int stars;

  bool get isCompleted =>
      type == LevelResultType.completed;

  bool get isFailed =>
      type == LevelResultType.failed;

  bool get hasStars =>
      stars > 0;

  bool get allGoalsCompleted =>
      totalGoals > 0 &&
      completedGoals >= totalGoals;

  double get goalProgress {
    if (totalGoals <= 0) {
      return 0.0;
    }

    final progress =
        completedGoals / totalGoals;

    if (progress <= 0) {
      return 0.0;
    }

    if (progress >= 1) {
      return 1.0;
    }

    return progress;
  }

  LevelResult copyWith({
    int? levelNumber,
    LevelResultType? type,
    int? score,
    int? movesUsed,
    int? movesRemaining,
    int? completedGoals,
    int? totalGoals,
    int? stars,
  }) {
    return LevelResult(
      levelNumber:
          levelNumber ?? this.levelNumber,
      type: type ?? this.type,
      score: score ?? this.score,
      movesUsed:
          movesUsed ?? this.movesUsed,
      movesRemaining:
          movesRemaining ?? this.movesRemaining,
      completedGoals:
          completedGoals ?? this.completedGoals,
      totalGoals:
          totalGoals ?? this.totalGoals,
      stars: stars ?? this.stars,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LevelResult &&
        other.levelNumber ==
            levelNumber &&
        other.type == type &&
        other.score == score &&
        other.movesUsed ==
            movesUsed &&
        other.movesRemaining ==
            movesRemaining &&
        other.completedGoals ==
            completedGoals &&
        other.totalGoals ==
            totalGoals &&
        other.stars == stars;
  }

  @override
  int get hashCode {
    return Object.hash(
      levelNumber,
      type,
      score,
      movesUsed,
      movesRemaining,
      completedGoals,
      totalGoals,
      stars,
    );
  }

  @override
  String toString() {
    return 'LevelResult('
        'levelNumber: $levelNumber, '
        'type: $type, '
        'score: $score, '
        'movesUsed: $movesUsed, '
        'movesRemaining: $movesRemaining, '
        'completedGoals: $completedGoals, '
        'totalGoals: $totalGoals, '
        'stars: $stars'
        ')';
  }
}
