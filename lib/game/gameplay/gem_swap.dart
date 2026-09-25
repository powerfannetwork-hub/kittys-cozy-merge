import 'package:flutter/foundation.dart';

import '../board/board_position.dart';

@immutable
class GemSwap {
  const GemSwap({
    required this.from,
    required this.to,
  });

  final BoardPosition from;
  final BoardPosition to;

  bool get isAdjacent => from.isAdjacentTo(to);

  @override
  bool operator ==(Object other) {
    return other is GemSwap &&
        other.from == from &&
        other.to == to;
  }

  @override
  int get hashCode => Object.hash(from, to);

  @override
  String toString() {
    return 'GemSwap(from: $from, to: $to)';
  }
}
