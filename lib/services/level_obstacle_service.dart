import 'dart:math';

class LevelObstacleService {
  static final Random _random = Random();

  /// Determines whether the current level should contain Ice.
  static bool shouldHaveIce(int level) {
    if (level < 30) {
      return false;
    }

    if (level == 30) {
      return true;
    }

    final roll = _random.nextInt(100);

    if (level < 60) {
      return roll < 45;
    }

    if (level < 90) {
      return roll < 50;
    }

    if (level < 120) {
      return roll < 55;
    }

    return roll < 60;
  }

  /// Returns the number of Ice obstacles for the current level.
  static int getIceCount(int level) {
    if (level < 30) {
      return 0;
    }

    if (level == 30) {
      return 3;
    }

    if (level < 60) {
      return 2 + _random.nextInt(4);
    }

    if (level < 90) {
      return 3 + _random.nextInt(5);
    }

    if (level < 120) {
      return 4 + _random.nextInt(5);
    }

    return 5 + _random.nextInt(6);
  }

  /// Returns the number of hits required to destroy Ice.
  static int getIceHp(int level) {
    if (level < 30) {
      return 0;
    }

    if (level < 60) {
      return 2;
    }

    if (level < 120) {
      return 2 + (level % 3 == 0 ? 1 : 0);
    }

    if (level < 180) {
      return 3;
    }

    return 3 + (level % 5 == 0 ? 1 : 0);
  }
}
