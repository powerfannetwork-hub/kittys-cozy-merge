import '../board/game_board.dart';
import '../board/board_position.dart';
import 'match_result.dart';

class MatchDetector {
  const MatchDetector();

  MatchResult findMatches(GameBoard board) {
    final positions = <BoardPosition>{};
    final horizontalMatches = <List<BoardPosition>>[];
    final verticalMatches = <List<BoardPosition>>[];

    _findHorizontalMatches(
      board,
      positions,
      horizontalMatches,
    );

    _findVerticalMatches(
      board,
      positions,
      verticalMatches,
    );

    return MatchResult(
      positions: Set.unmodifiable(positions),
      horizontalMatches: List.unmodifiable(
        horizontalMatches,
      ),
      verticalMatches: List.unmodifiable(
        verticalMatches,
      ),
    );
  }

  void _findHorizontalMatches(
    GameBoard board,
    Set<BoardPosition> positions,
    List<List<BoardPosition>> matches,
  ) {
    for (int row = 0; row < board.rows; row++) {
      int column = 0;

      while (column < board.columns) {
        final start = BoardPosition(
          row: row,
          column: column,
        );

        final gem = board.gemAt(start);

        if (gem == null) {
          column++;
          continue;
        }

        final currentMatch = <BoardPosition>[
          start,
        ];

        int nextColumn = column + 1;

        while (nextColumn < board.columns) {
          final nextPosition = BoardPosition(
            row: row,
            column: nextColumn,
          );

          final nextGem = board.gemAt(nextPosition);

          if (nextGem == null ||
              nextGem.type != gem.type) {
            break;
          }

          currentMatch.add(nextPosition);
          nextColumn++;
        }

        if (currentMatch.length >= 3) {
          final match = List<BoardPosition>.unmodifiable(
            currentMatch,
          );

          matches.add(match);
          positions.addAll(match);
        }

        column = nextColumn;
      }
    }
  }

  void _findVerticalMatches(
    GameBoard board,
    Set<BoardPosition> positions,
    List<List<BoardPosition>> matches,
  ) {
    for (int column = 0; column < board.columns; column++) {
      int row = 0;

      while (row < board.rows) {
        final start = BoardPosition(
          row: row,
          column: column,
        );

        final gem = board.gemAt(start);

        if (gem == null) {
          row++;
          continue;
        }

        final currentMatch = <BoardPosition>[
          start,
        ];

        int nextRow = row + 1;

        while (nextRow < board.rows) {
          final nextPosition = BoardPosition(
            row: nextRow,
            column: column,
          );

          final nextGem = board.gemAt(nextPosition);

          if (nextGem == null ||
              nextGem.type != gem.type) {
            break;
          }

          currentMatch.add(nextPosition);
          nextRow++;
        }

        if (currentMatch.length >= 3) {
          final match = List<BoardPosition>.unmodifiable(
            currentMatch,
          );

          matches.add(match);
          positions.addAll(match);
        }

        row = nextRow;
      }
    }
  }
}
