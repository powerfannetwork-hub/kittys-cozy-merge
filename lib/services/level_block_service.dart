import 'dart:math';

class LevelBlockService {
  static final Random _random = Random();

  /// Returns the initial HP of a Block for the given level.
  static int getBlockHp(int level) {
    if (level < 60) {
      return 0;
    }

    if (level < 120) {
      return 1;
    }

    if (level < 180) {
      return 2;
    }

    if (level < 240) {
      return 3;
    }

    return 4;
  }

  /// Returns whether Block can appear on the current level.
  static bool canHaveBlock(int level) {
    return level >= 60;
  }

  /// Determines whether the current level should contain Blocks.
  static bool shouldHaveBlock(int level) {
    if (level < 60) {
      return false;
    }

    if (level == 60) {
      return true;
    }

    final roll = _random.nextInt(100);

    if (level < 90) {
      return roll < 35;
    }

    if (level < 120) {
      return roll < 40;
    }

    if (level < 180) {
      return roll < 45;
    }

    if (level < 240) {
      return roll < 50;
    }

    return roll < 55;
  }

  /// Returns the maximum number of Blocks for the current level.
  static int getBlockCount(int level) {
    if (!shouldHaveBlock(level)) {
      return 0;
    }

    if (level < 60) {
      return 0;
    }

    if (level < 90) {
      return 2;
    }

    if (level < 120) {
      return 3;
    }

    if (level < 180) {
      return 4;
    }

    if (level < 240) {
      return 5;
    }

    return 6;
  }
}
