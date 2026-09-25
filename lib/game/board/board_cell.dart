import 'package:flutter/foundation.dart';

import '../gems/gem.dart';
import 'board_position.dart';

@immutable
class BoardCell {
  const BoardCell({
    required this.position,
    this.gem,
    this.isBlocked = false,
    this.isLocked = false,
    this.iceLayers = 0,
  });

  final BoardPosition position;
  final Gem? gem;
  final bool isBlocked;
  final bool isLocked;
  final int iceLayers;

  bool get hasGem => gem != null;

  bool get hasIce => iceLayers > 0;

  bool get isAvailable =>
      !isBlocked && !isLocked && !hasIce;

  BoardCell copyWith({
    BoardPosition? position,
    Gem? gem,
    bool? isBlocked,
    bool? isLocked,
    int? iceLayers,
    bool clearGem = false,
  }) {
    return BoardCell(
      position: position ?? this.position,
      gem: clearGem ? null : (gem ?? this.gem),
      isBlocked: isBlocked ?? this.isBlocked,
      isLocked: isLocked ?? this.isLocked,
      iceLayers: iceLayers ?? this.iceLayers,
    );
  }

  BoardCell removeGem() {
    return copyWith(clearGem: true);
  }

  BoardCell moveGemTo(BoardPosition newPosition) {
    final currentGem = gem;

    return BoardCell(
      position: newPosition,
      gem: currentGem?.copyWith(
        position: newPosition,
      ),
      isBlocked: isBlocked,
      isLocked: isLocked,
      iceLayers: iceLayers,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BoardCell &&
        other.position == position &&
        other.gem == gem &&
        other.isBlocked == isBlocked &&
        other.isLocked == isLocked &&
        other.iceLayers == iceLayers;
  }

  @override
  int get hashCode {
    return Object.hash(
      position,
      gem,
      isBlocked,
      isLocked,
      iceLayers,
    );
  }

  @override
  String toString() {
    return 'BoardCell('
        'position: $position, '
        'gem: $gem, '
        'blocked: $isBlocked, '
        'locked: $isLocked, '
        'iceLayers: $iceLayers'
        ')';
  }
}
