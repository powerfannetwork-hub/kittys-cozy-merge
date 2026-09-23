import 'dart:math';

import 'locked_tile_service.dart';

class LevelLockedTileService {
  static final Random _random = Random();

  /// Determines whether the current level should contain Locked Tiles.
  static bool shouldHaveLockedTile(int level) {
    if (level < 90) {
      return false;
    }

    if (level == 90) {
      return true;
    }

    final roll = _random.nextInt(100);

    if (level < 120) {
      return roll < 35;
    }

    if (level < 180) {
      return roll < 40;
    }

    if (level < 240) {
      return roll < 45;
    }

    return roll < 50;
  }

  /// Returns the number of Locked Tiles for the current level.
  static int getLockedTileCount(int level) {
    if (!shouldHaveLockedTile(level)) {
      return 0;
    }

    return LockedTileService.getLockedTileCount(level);
  }

  /// Returns the HP of Locked Tiles for the current level.
  static int getLockedHp(int level) {
    return LockedTileService.getLockedHp(level);
  }
}
