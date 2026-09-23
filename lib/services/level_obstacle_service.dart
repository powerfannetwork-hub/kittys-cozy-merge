import 'dart:math';

class LevelObstacleService {
  static final Random _random = Random();

  /// Returns the number of Ice obstacles for the current level.
  ///
  /// Level 1-29: No Ice.
  /// Level 30: Ice is guaranteed.
  /// After Level 30: Ice appears only on selected levels.
  static int getIceCount(int level) {
    if (level < 30) {
      return 0;
    }

    if (level == 30) {
      return 3;
    }

    final roll = _random.nextInt(100);

    if (level < 60) {
      if (roll >= 45) {
        return 0;
      }

      return 2 + _random.nextInt(4);
    }

    if (level < 90) {
      if (roll >= 50) {
        return 0;
      }

      return 3 + _random.nextInt(5);
    }

    if (level < 120) {
      if (roll >= 55) {
        return 0;
      }

      return 4 + _random.nextInt(5);
    }

    if (roll >= 60) {
      return 0;
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
