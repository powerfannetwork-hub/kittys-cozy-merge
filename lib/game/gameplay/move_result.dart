import 'package:flutter/foundation.dart';

import '../board/board_position.dart';

@immutable
class MoveResult {
  const MoveResult({
    required this.from,
    required this.to,
    required this.movesRemaining,
    required this.matchedGemCount,
    required this.cascadeCount,
    required this.scoreGained,
  });

  final BoardPosition from;
  final BoardPosition to;

  final int movesRemaining;

  final int matchedGemCount;

  final int cascadeCount;

  final int scoreGained;

  bool get createdMatch => matchedGemCount > 0;

  @override
  String toString() {
    return 'MoveResult('
        'from: $from, '
        'to: $to, '
        'movesRemaining: $movesRemaining, '
        'matchedGemCount: $matchedGemCount, '
        'cascadeCount: $cascadeCount, '
        'scoreGained: $scoreGained'
        ')';
  }
}
