import 'dart:math';

import '../models/gem_tile.dart';
import '../models/gem_type.dart';

class BoardService {
  static const int rows = 8;
  static const int columns = 8;

  static final Random _random = Random();

  static GemType randomGem() {
    return GemType.values[
        _random.nextInt(GemType.values.length)];
  }

  static List<List<GemTile>> createBoard() {
    final board = List.generate(
      rows,
      (row) => List.generate(
        columns,
        (column) => GemTile(
          row: row,
          column: column,
          type: randomGem(),
        ),
      ),
    );

    while (findMatches(board).isNotEmpty) {
      removeMatches(board, findMatches(board));
      collapseBoard(board);
      refillBoard(board);
    }

    return board;
  }

  static bool areAdjacent(
    GemTile first,
    GemTile second,
  ) {
    final rowDiff =
        (first.row - second.row).abs();

    final colDiff =
        (first.column - second.column).abs();

    return rowDiff + colDiff == 1;
  }

  static void swapTiles(
    List<List<GemTile>> board,
    GemTile first,
    GemTile second,
  ) {
    final temp = first.type;

    first.type = second.type;
    second.type = temp;
  }

  static bool trySwap(
    List<List<GemTile>> board,
    GemTile first,
    GemTile second,
  ) {
    swapTiles(board, first, second);

    final matches = findMatches(board);

    if (matches.isEmpty) {
      swapTiles(board, first, second);
      return false;
    }

    return true;
  }

  static List<GemTile> findMatches(
    List<List<GemTile>> board,
  ) {
    final matches = <GemTile>{};

    // Horizontal

    for (int row = 0; row < rows; row++) {
      int streak = 1;

      for (int col = 1; col < columns; col++) {
        if (board[row][col].type ==
            board[row][col - 1].type) {
          streak++;
        } else {
          if (streak >= 3) {
            for (int i = 0; i < streak; i++) {
              matches.add(
                board[row][col - 1 - i],
              );
            }
          }

          streak = 1;
        }
      }

      if (streak >= 3) {
        for (int i = 0; i < streak; i++) {
          matches.add(
            board[row][columns - 1 - i],
          );
        }
      }
    }

    // Vertical

    for (int col = 0; col < columns; col++) {
      int streak = 1;

      for (int row = 1; row < rows; row++) {
        if (board[row][col].type ==
            board[row - 1][col].type) {
          streak++;
        } else {
          if (streak >= 3) {
            for (int i = 0; i < streak; i++) {
              matches.add(
                board[row - 1 - i][col],
              );
            }
          }

          streak = 1;
        }
      }

      if (streak >= 3) {
        for (int i = 0; i < streak; i++) {
          matches.add(
            board[rows - 1 - i][col],
          );
        }
      }
    }

    return matches.toList();
  }

  static int calculateScore(
    List<GemTile> matches,
  ) {
    return matches.length * 10;
  }

  static void removeMatches(
    List<List<GemTile>> board,
    List<GemTile> matches,
  ) {
    for (final tile in matches) {
      board[tile.row][tile.column].isMatched =
          true;
    }
  }

  static void collapseBoard(
    List<List<GemTile>> board,
  ) {
    for (int col = 0; col < columns; col++) {
      int emptyRow = rows - 1;

      for (int row = rows - 1;
          row >= 0;
          row--) {
        if (!board[row][col].isMatched) {
          if (row != emptyRow) {
            board[emptyRow][col].type =
                board[row][col].type;

            board[emptyRow][col].isMatched =
                false;
          }

          emptyRow--;
        }
      }

      while (emptyRow >= 0) {
        board[emptyRow][col].isMatched =
            true;

        emptyRow--;
      }
    }
  }

  static void refillBoard(
    List<List<GemTile>> board,
  ) {
    for (int row = 0; row < rows; row++) {
      for (int col = 0;
          col < columns;
          col++) {
        if (board[row][col].isMatched) {
          board[row][col].type =
              randomGem();

          board[row][col].isMatched =
              false;
        }
      }
    }
  }

  static int processBoard(
    List<List<GemTile>> board,
  ) {
    int totalScore = 0;

    while (true) {
      final matches = findMatches(board);

      if (matches.isEmpty) {
        break;
      }

      totalScore +=
          calculateScore(matches);

      removeMatches(board, matches);

      collapseBoard(board);

      refillBoard(board);
    }

    return totalScore;
  }
}
