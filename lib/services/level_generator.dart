import '../models/level_model.dart';

class LevelGenerator {
  LevelGenerator._();

  static const int maxLevels = 500;

  static List<LevelModel> generateAllLevels() {
    return List.generate(
      maxLevels,
      (index) => LevelModel.fromLevel(index + 1),
    );
  }

  static LevelModel getLevel(int level) {
    if (level < 1) {
      return LevelModel.fromLevel(1);
    }

    if (level > maxLevels) {
      return LevelModel.fromLevel(maxLevels);
    }

    return LevelModel.fromLevel(level);
  }

  static bool isBossLevel(int level) {
    return level >= 451;
  }

  static bool givesGemReward(int level) {
    return level % 10 == 0;
  }
}
