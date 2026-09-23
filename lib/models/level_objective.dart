import 'gem_type.dart';

enum ObjectiveType {
  collectGems,
  clearBlocks,
  scoreTarget,
}

class LevelObjective {
  final ObjectiveType type;

  final GemType? gemType;

  final int target;

  const LevelObjective({
    required this.type,
    required this.target,
    this.gemType,
  });

  factory LevelObjective.collectGem(
    GemType gemType,
    int amount,
  ) {
    return LevelObjective(
      type: ObjectiveType.collectGems,
      gemType: gemType,
      target: amount,
    );
  }

  factory LevelObjective.clearBlocks(
    int amount,
  ) {
    return LevelObjective(
      type: ObjectiveType.clearBlocks,
      target: amount,
    );
  }

  factory LevelObjective.scoreTarget(
    int score,
  ) {
    return LevelObjective(
      type: ObjectiveType.scoreTarget,
      target: score,
    );
  }

  String get title {
    switch (type) {
      case ObjectiveType.collectGems:
        return 'Collect $target ${gemType?.nameLabel ?? ''} Gems';

      case ObjectiveType.clearBlocks:
        return 'Clear $target Blocks';

      case ObjectiveType.scoreTarget:
        return 'Reach Score $target';
    }
  }
}
