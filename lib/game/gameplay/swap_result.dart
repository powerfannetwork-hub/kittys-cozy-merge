import 'package:flutter/foundation.dart';

import '../board/board_position.dart';

enum SwapStatus {
  successful,
  noMatch,
  invalid,
}

@immutable
class SwapResult {
  const SwapResult({
    required this.status,
    required this.from,
    required this.to,
    this.matchedPositions = const <BoardPosition>{},
    this.cascadeCount = 0,
    this.scoreGained = 0,
  });

  final SwapStatus status;
  final BoardPosition from;
  final BoardPosition to;

  final Set<BoardPosition> matchedPositions;

  final int cascadeCount;

  final int scoreGained;

  bool get isSuccessful =>
      status == SwapStatus.successful;

  bool get wasRejected =>
      status == SwapStatus.noMatch ||
      status == SwapStatus.invalid;

  static SwapResult invalid({
    required BoardPosition from,
    required BoardPosition to,
  }) {
    return SwapResult(
      status: SwapStatus.invalid,
      from: from,
      to: to,
    );
  }

  static SwapResult noMatch({
    required BoardPosition from,
    required BoardPosition to,
  }) {
    return SwapResult(
      status: SwapStatus.noMatch,
      from: from,
      to: to,
    );
  }

  @override
  String toString() {
    return 'SwapResult('
        'status: $status, '
        'from: $from, '
        'to: $to, '
        'matched: ${matchedPositions.length}, '
        'cascades: $cascadeCount, '
        'score: $scoreGained'
        ')';
  }
}
