class LockedTileService {
  /// Returns the initial HP of a Locked Tile.
  static int getLockedHp(int level) {
    if (level < 90) {
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

  /// Returns whether Locked Tiles can appear on the current level.
  static bool canHaveLockedTile(int level) {
    return level >= 90;
  }

  /// Returns the maximum number of Locked Tiles.
  static int getLockedTileCount(int level) {
    if (level < 90) {
      return 0;
    }

    if (level < 120) {
      return 2;
    }

    if (level < 180) {
      return 3;
    }

    if (level < 240) {
      return 4;
    }

    return 5;
  }
}
