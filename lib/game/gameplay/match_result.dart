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

  BoardPosition? get specialGemPosition {
    if (!hasMatch) {
      return null;
    }

    // A five-or-more straight match gets a color bomb.
    // Prefer the position that was part of the longest match.
    if (hasFiveOrMoreMatch) {
      return _findLongestMatch().elementAt(
        _findLongestMatch().length ~/ 2,
      );
    }

    // L/T shapes create a bomb.
    if (hasLTShape) {
      final crossingPosition = _findCrossingPosition();

      if (crossingPosition != null) {
        return crossingPosition;
      }
    }

    // A four-match creates a rocket.
    if (hasFourOrMoreMatch) {
      final horizontal = _longestHorizontalMatch();

      if (horizontal != null && horizontal.length >= 4) {
        return horizontal[horizontal.length ~/ 2];
      }

      final vertical = _longestVerticalMatch();

      if (vertical != null && vertical.length >= 4) {
        return vertical[vertical.length ~/ 2];
      }
    }

    return null;
  }

  SpecialMatchType get specialMatchType {
    if (!hasMatch) {
      return SpecialMatchType.none;
    }

    if (hasFiveOrMoreMatch) {
      return SpecialMatchType.colorBomb;
    }

    if (hasLTShape) {
      return SpecialMatchType.bomb;
    }

    final horizontal = _longestHorizontalMatch();

    if (horizontal != null && horizontal.length >= 4) {
      return SpecialMatchType.rocketHorizontal;
    }

    final vertical = _longestVerticalMatch();

    if (vertical != null && vertical.length >= 4) {
      return SpecialMatchType.rocketVertical;
    }

    return SpecialMatchType.none;
  }

  List<BoardPosition> _findLongestMatch() {
    final allMatches = <List<BoardPosition>>[
      ...horizontalMatches,
      ...verticalMatches,
    ];

    if (allMatches.isEmpty) {
      return const <BoardPosition>[];
    }

    allMatches.sort(
      (first, second) =>
          second.length.compareTo(first.length),
    );

    return allMatches.first;
  }

  List<BoardPosition>? _longestHorizontalMatch() {
    if (horizontalMatches.isEmpty) {
      return null;
    }

    List<BoardPosition>? longest;

    for (final match in horizontalMatches) {
      if (longest == null ||
          match.length > longest.length) {
        longest = match;
      }
    }

    return longest;
  }

  List<BoardPosition>? _longestVerticalMatch() {
    if (verticalMatches.isEmpty) {
      return null;
    }

    List<BoardPosition>? longest;

    for (final match in verticalMatches) {
      if (longest == null ||
          match.length > longest.length) {
        longest = match;
      }
    }

    return longest;
  }

  BoardPosition? _findCrossingPosition() {
    for (final horizontal in horizontalMatches) {
      for (final vertical in verticalMatches) {
        for (final position in horizontal) {
          if (vertical.contains(position)) {
            return position;
          }
        }
      }
    }

    return null;
  }

  static const MatchResult empty = MatchResult(
    positions: <BoardPosition>{},
    horizontalMatches: <List<BoardPosition>>[],
    verticalMatches: <List<BoardPosition>>[],
  );
}

enum SpecialMatchType {
  none,
  rocketHorizontal,
  rocketVertical,
  bomb,
  colorBomb,
}
