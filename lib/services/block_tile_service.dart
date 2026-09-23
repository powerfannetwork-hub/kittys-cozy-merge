class BlockTileService {
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

  /// Returns the maximum number of Blocks for the current level.
  static int getBlockCount(int level) {
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
