import 'package:flutter/foundation.dart';

import '../gems/gem.dart';
import '../obstacles/obstacle_type.dart';
import 'board_position.dart';

@immutable
class BoardCell {
  const BoardCell({
    required this.position,
    this.gem,
    this.obstacleType = ObstacleType.none,
    this.iceLayers = 0,
    this.isBlocked = false,
    this.isLocked = false,
  });

  final BoardPosition position;

  final Gem? gem;

  final ObstacleType obstacleType;

  /// Number of ice layers covering this cell.
  ///
  /// Ice is a cover/obstacle layer, not a hard movement block.
  /// A gem can exist on an ice cell.
  final int iceLayers;

  /// Hard block that prevents gem movement.
  final bool isBlocked;

  /// Locked tile that prevents gem movement until unlocked.
  final bool isLocked;

  bool get hasGem => gem != null;

  bool get hasIce =>
      obstacleType == ObstacleType.ice &&
      iceLayers > 0;

  bool get hasBlock =>
      obstacleType == ObstacleType.block ||
      isBlocked;

  bool get hasLockedTile =>
      obstacleType == ObstacleType.lockedTile ||
      isLocked;

  bool get hasHardObstacle =>
      hasBlock || hasLockedTile;

  bool get hasObstacle =>
      hasIce || hasHardObstacle;

  /// Whether a gem can occupy and move through this cell.
  ///
  /// Ice does NOT make the cell unavailable.
  /// Blocks and locked tiles are hard obstacles.
  bool get isAvailable => !hasHardObstacle;

  BoardCell copyWith({
    BoardPosition? position,
    Gem? gem,
    ObstacleType? obstacleType,
    int? iceLayers,
    bool? isBlocked,
    bool? isLocked,
    bool clearGem = false,
  }) {
    return BoardCell(
      position: position ?? this.position,
      gem: clearGem ? null : (gem ?? this.gem),
      obstacleType: obstacleType ?? this.obstacleType,
      iceLayers: iceLayers ?? this.iceLayers,
      isBlocked: isBlocked ?? this.isBlocked,
      isLocked: isLocked ?? this.isLocked,
    );
  }

  BoardCell removeGem() {
    return copyWith(
      clearGem: true,
    );
  }

  BoardCell moveGemTo(
    BoardPosition newPosition,
  ) {
    final currentGem = gem;

    return BoardCell(
      position: newPosition,
      gem: currentGem?.copyWith(
        position: newPosition,
      ),
      obstacleType: obstacleType,
      iceLayers: iceLayers,
      isBlocked: isBlocked,
      isLocked: isLocked,
    );
  }

  BoardCell withIce(int layers) {
    if (layers <= 0) {
      return copyWith(
        obstacleType: ObstacleType.none,
        iceLayers: 0,
      );
    }

    return copyWith(
      obstacleType: ObstacleType.ice,
      iceLayers: layers,
      isBlocked: false,
      isLocked: false,
    );
  }

  BoardCell withBlock() {
    return copyWith(
      obstacleType: ObstacleType.block,
      iceLayers: 0,
      isBlocked: true,
      isLocked: false,
    );
  }

  BoardCell withLockedTile() {
    return copyWith(
      obstacleType: ObstacleType.lockedTile,
      iceLayers: 0,
      isBlocked: false,
      isLocked: true,
    );
  }

  BoardCell removeObstacle() {
    return copyWith(
      obstacleType: ObstacleType.none,
      iceLayers: 0,
      isBlocked: false,
      isLocked: false,
    );
  }

  BoardCell damageIce() {
    if (!hasIce) {
      return this;
    }

    final remainingLayers = iceLayers - 1;

    if (remainingLayers <= 0) {
      return copyWith(
        obstacleType: ObstacleType.none,
        iceLayers: 0,
      );
    }

    return copyWith(
      obstacleType: ObstacleType.ice,
      iceLayers: remainingLayers,
    );
  }

  BoardCell unlock() {
    if (!hasLockedTile) {
      return this;
    }

    return copyWith(
      obstacleType: ObstacleType.none,
      isLocked: false,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BoardCell &&
        other.position == position &&
        other.gem == gem &&
        other.obstacleType == obstacleType &&
        other.iceLayers == iceLayers &&
        other.isBlocked == isBlocked &&
        other.isLocked == isLocked;
  }

  @override
  int get hashCode {
    return Object.hash(
      position,
      gem,
      obstacleType,
      iceLayers,
      isBlocked,
      isLocked,
    );
  }

  @override
  String toString() {
    return 'BoardCell('
        'position: $position, '
        'gem: $gem, '
        'obstacleType: $obstacleType, '
        'iceLayers: $iceLayers, '
        'isBlocked: $isBlocked, '
        'isLocked: $isLocked'
        ')';
  }
}
