import 'package:flutter/foundation.dart';

import '../../models/gem_type.dart';
import '../board/board_position.dart';

enum GemSpecialType {
  normal,
  rocketHorizontal,
  rocketVertical,
  bomb,
  colorBomb,
}

@immutable
class Gem {
  const Gem({
    required this.id,
    required this.type,
    required this.position,
    this.specialType = GemSpecialType.normal,
  });

  final String id;
  final GemType type;
  final BoardPosition position;
  final GemSpecialType specialType;

  bool get isSpecial =>
      specialType != GemSpecialType.normal;

  Gem copyWith({
    String? id,
    GemType? type,
    BoardPosition? position,
    GemSpecialType? specialType,
  }) {
    return Gem(
      id: id ?? this.id,
      type: type ?? this.type,
      position: position ?? this.position,
      specialType: specialType ?? this.specialType,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Gem &&
        other.id == id &&
        other.type == type &&
        other.position == position &&
        other.specialType == specialType;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      type,
      position,
      specialType,
    );
  }
}
