import 'package:flutter/foundation.dart';

import '../../models/gem_type.dart';
import 'board_position.dart';

@immutable
class BoardCell {
  const BoardCell({
    required this.position,
    this.gemType,
    this.isBlocked = false,
    this.isLocked = false,
    this.iceLayers = 0,
  });

  final BoardPosition position;
  final GemType? gemType;
  final bool isBlocked;
  final bool isLocked;
  final int iceLayers;

  bool get hasGem => gemType != null;

  bool get hasIce => iceLayers > 0;

  bool get isAvailable =>
      !isBlocked && !isLocked && !hasIce;

  BoardCell copyWith({
    BoardPosition? position,
    GemType? gemType,
    bool? isBlocked,
    bool? isLocked,
    int? iceLayers,
    bool clearGem = false,
  }) {
    return BoardCell(
      position: position ?? this.position,
      gemType: clearGem ? null : (gemType ?? this.gemType),
      isBlocked: isBlocked ?? this.isBlocked,
      isLocked: isLocked ?? this.isLocked,
      iceLayers: iceLayers ?? this.iceLayers,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BoardCell &&
        other.position == position &&
        other.gemType == gemType &&
        other.isBlocked == isBlocked &&
        other.isLocked == isLocked &&
        other.iceLayers == iceLayers;
  }

  @override
  int get hashCode {
    return Object.hash(
      position,
      gemType,
      isBlocked,
      isLocked,
      iceLayers,
    );
  }
}
