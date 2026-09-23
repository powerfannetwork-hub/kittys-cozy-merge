import 'dart:math';

import 'block_tile_service.dart';

class LevelBlockService {
  static final Random _random = Random();

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

  /// Returns the number of Blocks for the current level.
  static int getBlockCount(int level) {
    if (!shouldHaveBlock(level)) {
      return 0;
    }

    return BlockTileService.getBlockCount(level);
  }

  /// Returns the HP of Blocks for the current level.
  static int getBlockHp(int level) {
    return BlockTileService.getBlockHp(level);
  }
}
