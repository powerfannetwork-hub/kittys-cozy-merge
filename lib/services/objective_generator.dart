import '../models/gem_type.dart';
import '../models/level_objective.dart';

class ObjectiveGenerator {
  ObjectiveGenerator._();

  static LevelObjective getObjective(
    int level,
  ) {
    // Kowane level 10 score objective

    if (level % 10 == 0) {
      return LevelObjective.scoreTarget(
        1000 + (level * 50),
      );
    }

    // Kowane level 30 block objective

    if (level % 30 == 0) {
      return LevelObjective.clearBlocks(
        10 + (level ~/ 10),
      );
    }

    final gem =
        GemType.values[
          level %
              GemType.values.length,
        ];

    return LevelObjective.collectGem(
      gem,
      20 + (level ~/ 2),
    );
  }
}
