import 'package:flutter/foundation.dart';

import '../board/board_position.dart';

@immutable
class MatchResult {
  const MatchResult({
    required this.positions,
    required this.horizontalMatches,
    required this.verticalMatches,
  });

  final Set<BoardPosition> positions;

  final List<List<BoardPosition>> horizontalMatches;

  final List<List<BoardPosition>> verticalMatches;

  bool get hasMatch => positions.isNotEmpty;

  int get matchedGemCount => positions.length;

  bool get hasFourOrMoreMatch {
    return horizontalMatches.any(
          (match) => match.length >= 4,
        ) ||
        verticalMatches.any(
          (match) => match.length >= 4,
        );
  }

  bool get hasFiveOrMoreMatch {
    return horizontalMatches.any(
          (match) => match.length >= 5,
        ) ||
        verticalMatches.any(
          (match) => match.length >= 5,
        );
  }

  bool get hasLTShape {
    for (final horizontal in horizontalMatches) {
      for (final vertical in verticalMatches) {
        if (horizontal.any(vertical.contains)) {
          return true;
        }
      }
    }

    return false;
  }

  static const MatchResult empty = MatchResult(
    positions: <BoardPosition>{},
    horizontalMatches: <List<BoardPosition>>[],
    verticalMatches: <List<BoardPosition>>[],
  );
}
