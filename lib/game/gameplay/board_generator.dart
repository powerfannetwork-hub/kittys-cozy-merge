import 'dart:math';

import '../../models/gem_type.dart';
import '../board/board_position.dart';
import '../board/game_board.dart';
import '../gems/gem.dart';
import 'match_detector.dart';

class BoardGenerator {
  BoardGenerator({
    Random? random,
    MatchDetector? matchDetector,
  })  : _random = random ?? Random(),
        _matchDetector = matchDetector ?? const MatchDetector();

  final Random _random;
  final MatchDetector _matchDetector;

  static const List<GemType> availableGemTypes = <GemType>[
    GemType.pink,
    GemType.blue,
    GemType.purple,
    GemType.green,
    GemType.yellow,
    GemType.orange,
  ];

  GameBoard generate({
    required int rows,
    required int columns,
  }) {
    if (rows <= 0 || columns <= 0) {
      throw ArgumentError(
        'Board rows and columns must be greater than zero.',
      );
    }

    final board = GameBoard(
      rows: rows,
      columns: columns,
    );

    for (int row = 0; row < rows; row++) {
      for (int column = 0; column < columns; column++) {
        final position = BoardPosition(
          row: row,
          column: column,
        );

        final type = _randomGemTypeWithoutImmediateMatch(
          board,
          position,
        );

        board.setGem(
          position,
          Gem(
            id: _createGemId(position),
            type: type,
            position: position,
          ),
        );
      }
    }

    if (_matchDetector.findMatches(board).hasMatch) {
      return generate(
        rows: rows,
        columns: columns,
      );
    }

    return board;
  }

  GemType _randomGemTypeWithoutImmediateMatch(
    GameBoard board,
    BoardPosition position,
  ) {
    final possibleTypes = List<GemType>.from(
      availableGemTypes,
    );

    possibleTypes.shuffle(_random);

    for (final type in possibleTypes) {
      if (!_createsImmediateHorizontalMatch(
            board,
            position,
            type,
          ) &&
          !_createsImmediateVerticalMatch(
            board,
            position,
            type,
          )) {
        return type;
      }
    }

    return possibleTypes.first;
  }

  bool _createsImmediateHorizontalMatch(
    GameBoard board,
    BoardPosition position,
    GemType type,
  ) {
    if (position.column < 2) {
      return false;
    }

    final leftOne = BoardPosition(
      row: position.row,
      column: position.column - 1,
    );

    final leftTwo = BoardPosition(
      row: position.row,
      column: position.column - 2,
    );

    return board.gemAt(leftOne)?.type == type &&
        board.gemAt(leftTwo)?.type == type;
  }

  bool _createsImmediateVerticalMatch(
    GameBoard board,
    BoardPosition position,
    GemType type,
  ) {
    if (position.row < 2) {
      return false;
    }

    final upperOne = BoardPosition(
      row: position.row - 1,
      column: position.column,
    );

    final upperTwo = BoardPosition(
      row: position.row - 2,
      column: position.column,
    );

    return board.gemAt(upperOne)?.type == type &&
        board.gemAt(upperTwo)?.type == type;
  }

  String _createGemId(BoardPosition position) {
    final timestamp = DateTime.now().microsecondsSinceEpoch;

    return 'gem_${timestamp}_${position.row}_${position.column}_${_random.nextInt(100000)}';
  }
}
