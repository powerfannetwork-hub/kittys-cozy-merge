import 'package:flutter/foundation.dart';

import 'gem_type.dart';

enum LevelGoalType {
  collectGem,
  breakIce,
  breakBlock,
  unlockTile,
  reachScore,
}

@immutable
class LevelGoal {
  const LevelGoal({
    required this.type,
    required this.target,
    this.gemType,
    this.current = 0,
  }) : assert(target > 0);

  final LevelGoalType type;

  /// The amount required to complete this goal.
  final int target;

  /// Used only by [LevelGoalType.collectGem].
  final GemType? gemType;

  /// Current progress toward the goal.
  final int current;

  /// Whether this goal has been completed.
  bool get isComplete => current >= target;

  /// Remaining amount needed to complete the goal.
  int get remaining {
    final value = target - current;

    return value > 0 ? value : 0;
  }

  /// Progress from 0.0 to 1.0.
  double get progress {
    if (target <= 0) {
      return 1.0;
    }

    final value = current / target;

    if (value <= 0) {
      return 0.0;
    }

    if (value >= 1) {
      return 1.0;
    }

    return value;
  }

  /// A short display name for the goal.
  String get title {
    switch (type) {
      case LevelGoalType.collectGem:
        return 'Collect Gems';

      case LevelGoalType.breakIce:
        return 'Break Ice';

      case LevelGoalType.breakBlock:
        return 'Break Blocks';

      case LevelGoalType.unlockTile:
        return 'Unlock Tiles';

      case LevelGoalType.reachScore:
        return 'Reach Score';
    }
  }

  /// Creates a new goal with updated values.
  LevelGoal copyWith({
    LevelGoalType? type,
    int? target,
    GemType? gemType,
    int? current,
    bool clearGemType = false,
  }) {
    return LevelGoal(
      type: type ?? this.type,
      target: target ?? this.target,
      gemType:
          clearGemType ? null : (gemType ?? this.gemType),
      current: current ?? this.current,
    );
  }

  /// Adds progress to this goal.
  ///
  /// Progress is capped at [target], so a completed
  /// goal never exceeds its required amount.
  LevelGoal addProgress(int amount) {
    if (amount <= 0 || isComplete) {
      return this;
    }

    final nextValue = current + amount;

    return copyWith(
      current:
          nextValue > target ? target : nextValue,
    );
  }

  /// Sets progress directly while keeping it inside
  /// the valid range.
  LevelGoal setProgress(int value) {
    if (value <= 0) {
      return copyWith(current: 0);
    }

    if (value >= target) {
      return copyWith(current: target);
    }

    return copyWith(current: value);
  }

  /// Checks whether this goal is configured correctly.
  ///
  /// A collect-gem goal must specify a [gemType].
  /// Other goal types must not depend on a gem type.
  bool get isValid {
    switch (type) {
      case LevelGoalType.collectGem:
        return gemType != null && target > 0;

      case LevelGoalType.breakIce:
      case LevelGoalType.breakBlock:
      case LevelGoalType.unlockTile:
      case LevelGoalType.reachScore:
        return gemType == null && target > 0;
    }
  }

  @override
  bool operator ==(Object other) {
    return other is LevelGoal &&
        other.type == type &&
        other.target == target &&
        other.gemType == gemType &&
        other.current == current;
  }

  @override
  int get hashCode {
    return Object.hash(
      type,
      target,
      gemType,
      current,
    );
  }

  @override
  String toString() {
    return 'LevelGoal('
        'type: $type, '
        'target: $target, '
        'gemType: $gemType, '
        'current: $current'
        ')';
  }
}
