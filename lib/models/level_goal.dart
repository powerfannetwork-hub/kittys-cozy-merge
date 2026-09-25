import 'gem_type.dart';

enum LevelGoalType {
  collectGem,
  breakIce,
  breakBlock,
  unlockTile,
  reachScore,
}

class LevelGoal {
  const LevelGoal({
    required this.type,
    required this.target,
    this.gemType,
    this.current = 0,
  });

  final LevelGoalType type;
  final int target;
  final GemType? gemType;
  final int current;

  bool get isComplete => current >= target;

  LevelGoal copyWith({
    LevelGoalType? type,
    int? target,
    GemType? gemType,
    int? current,
  }) {
    return LevelGoal(
      type: type ?? this.type,
      target: target ?? this.target,
      gemType: gemType ?? this.gemType,
      current: current ?? this.current,
    );
  }
}
