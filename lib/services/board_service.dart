import 'dart:math';

import '../models/gem_tile.dart';
import '../models/gem_type.dart';

class BoardService {
  static const int rows = 8;
  static const int columns = 8;

  static final Random _random = Random();

  static List<List<GemTile>> createBoard() {
    return List.generate(
      rows,
      (row) => List.generate(
        columns,
        (column) => GemTile(
          row: row,
          column: column,
          type: GemType.values[
              _random.nextInt(GemType.values.length)],
        ),
      ),
    );
  }

  static bool areAdjacent(
    GemTile first,
    GemTile second,
  ) {
    final rowDiff =
        (first.row - second.row).abs();

    final columnDiff =
        (first.column - second.column).abs();

    return rowDiff + columnDiff == 1;
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

  static List<GemTile> findMatches(
    List<List<GemTile>> board,
  ) {
    final matches = <GemTile>[];

    // Horizontal

    for (int row = 0; row < rows; row++) {
      int count = 1;

      for (int col = 1; col < columns; col++) {
        if (board[row][col].type ==
            board[row][col - 1].type) {
          count++;
        } else {
          if (count >= 3) {
            for (int i = 0; i < count; i++) {
              matches.add(
                board[row][col - 1 - i],
              );
            }
          }

          count = 1;
        }
      }

      if (count >= 3) {
        for (int i = 0; i < count; i++) {
          matches.add(
            board[row][columns - 1 - i],
          );
        }
      }
    }

    // Vertical

    for (int col = 0; col < columns; col++) {
      int count = 1;

      for (int row = 1; row < rows; row++) {
        if (board[row][col].type ==
            board[row - 1][col].type) {
          count++;
        } else {
          if (count >= 3) {
            for (int i = 0; i < count; i++) {
              matches.add(
                board[row - 1 - i][col],
              );
            }
          }

          count = 1;
        }
      }

      if (count >= 3) {
        for (int i = 0; i < count; i++) {
          matches.add(
            board[rows - 1 - i][col],
          );
        }
      }
    }

    return matches.toSet().toList();
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
      board[tile.row][tile.column].type =
          GemType.values[
              _random.nextInt(
                GemType.values.length,
              )];
    }
  }
}
