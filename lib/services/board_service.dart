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

  /// Creates the game board.
  ///
  /// Level 1-29  = normal board.
  /// Level 30+   = Ice can appear.
  ///
  /// Ice strength:
  /// Level 30-59  = 2 HP
  /// Level 60-119 = 3 HP
  /// Level 120+   = 4 HP
  static List<List<GemTile>> createBoard({
    int level = 1,
  }) {
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

    // Remove starting matches so the player does not begin
    // with a free automatic match.
    while (findMatches(board).isNotEmpty) {
      final matches = findMatches(board);

      removeMatches(
        board,
        matches,
      );

      collapseBoard(board);
      refillBoard(board);
    }

    if (level >= 30) {
      _addIce(board, level);
    }

    return board;
  }

  /// Returns the Ice HP for the current level.
  static int _getIceHpForLevel(int level) {
    if (level >= 120) {
      return 4;
    }

    if (level >= 60) {
      return 3;
    }

    return 2;
  }

  /// Adds Ice to the board.
  ///
  /// Ice count gradually increases as levels become harder.
  /// The Ice HP depends on the level.
  static void _addIce(
    List<List<GemTile>> board,
    int level,
  ) {
    int iceCount;

    if (level < 30) {
      iceCount = 0;
    } else if (level < 60) {
      iceCount = 4;
    } else if (level < 90) {
      iceCount = 6;
    } else if (level < 120) {
      iceCount = 8;
    } else {
      iceCount = min(
        12,
        8 + ((level - 120) ~/ 30),
      );
    }

    final iceHp = _getIceHpForLevel(level);

    final availablePositions = <GemTile>[];

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < columns; col++) {
        availablePositions.add(
          board[row][col],
        );
      }
    }

    availablePositions.shuffle(_random);

    for (int i = 0;
        i < iceCount && i < availablePositions.length;
        i++) {
      final tile = availablePositions[i];

      tile.isObstacle = true;
      tile.iceHp = iceHp;
      tile.isMatched = false;
    }
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
    // Ice cannot be moved.
    if (first.isObstacle ||
        second.isObstacle) {
      return;
    }

    final temp = first.type;
    first.type = second.type;
    second.type = temp;
  }

  static bool trySwap(
    List<List<GemTile>> board,
    GemTile first,
    GemTile second,
  ) {
    // Ice cannot be selected for swapping.
    if (first.isObstacle ||
        second.isObstacle) {
      return false;
    }

    swapTiles(
      board,
      first,
      second,
    );

    final matches = findMatches(board);

    if (matches.isEmpty) {
      swapTiles(
        board,
        first,
        second,
      );

      return false;
    }

    return true;
  }

  static List<GemTile> findMatches(
    List<List<GemTile>> board,
  ) {
    final matches = <GemTile>{};

    // Horizontal matches.
    for (int row = 0; row < rows; row++) {
      int streak = 1;

      for (int col = 1;
          col < columns;
          col++) {
        if (board[row][col].type ==
            board[row][col - 1].type) {
          streak++;
        } else {
          if (streak >= 3) {
            for (int i = 0;
                i < streak;
                i++) {
              final tile =
                  board[row][col - 1 - i];

              if (!tile.isObstacle) {
                matches.add(tile);
              }
            }
          }

          streak = 1;
        }
      }

      if (streak >= 3) {
        for (int i = 0;
            i < streak;
            i++) {
          final tile =
              board[row][columns - 1 - i];

          if (!tile.isObstacle) {
            matches.add(tile);
          }
        }
      }
    }

    // Vertical matches.
    for (int col = 0;
        col < columns;
        col++) {
      int streak = 1;

      for (int row = 1;
          row < rows;
          row++) {
        if (board[row][col].type ==
            board[row - 1][col].type) {
          streak++;
        } else {
          if (streak >= 3) {
            for (int i = 0;
                i < streak;
                i++) {
              final tile =
                  board[row - 1 - i][col];

              if (!tile.isObstacle) {
                matches.add(tile);
              }
            }
          }

          streak = 1;
        }
      }

      if (streak >= 3) {
        for (int i = 0;
            i < streak;
            i++) {
          final tile =
              board[rows - 1 - i][col];

          if (!tile.isObstacle) {
            matches.add(tile);
          }
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

  /// Damages each Ice that is directly beside a match.
  ///
  /// One match event causes one damage to an Ice, even if
  /// several matched gems touch the same Ice.
  ///
  /// Example:
  /// 🧊4 -> 🧊3 -> 🧊2 -> 🧊1 -> broken
  static void damageAdjacentIce(
    List<List<GemTile>> board,
    List<GemTile> matches,
  ) {
    final iceToDamage = <GemTile>{};

    for (final matchedTile in matches) {
      final row = matchedTile.row;
      final column = matchedTile.column;

      final neighbors = <GemTile>[];

      if (row > 0) {
        neighbors.add(board[row - 1][column]);
      }

      if (row < rows - 1) {
        neighbors.add(board[row + 1][column]);
      }

      if (column > 0) {
        neighbors.add(board[row][column - 1]);
      }

      if (column < columns - 1) {
        neighbors.add(board[row][column + 1]);
      }

      for (final neighbor in neighbors) {
        if (neighbor.isObstacle &&
            neighbor.iceHp > 0) {
          iceToDamage.add(neighbor);
        }
      }
    }

    for (final ice in iceToDamage) {
      ice.iceHp--;

      if (ice.iceHp <= 0) {
        ice.iceHp = 0;
        ice.isObstacle = false;
        ice.isMatched = true;
      }
    }
  }

  static void removeMatches(
    List<List<GemTile>> board,
    List<GemTile> matches,
  ) {
    for (final tile in matches) {
      if (tile.isObstacle) {
        continue;
      }

      board[tile.row][tile.column]
          .isMatched = true;
    }
  }

  static void collapseBoard(
    List<List<GemTile>> board,
  ) {
    for (int col = 0;
        col < columns;
        col++) {
      int emptyRow = rows - 1;

      for (int row = rows - 1;
          row >= 0;
          row--) {
        final tile = board[row][col];

        if (tile.isObstacle) {
          continue;
        }

        if (!tile.isMatched) {
          if (row != emptyRow) {
            final destination =
                board[emptyRow][col];

            // Do not move into an Ice tile.
            if (!destination.isObstacle) {
              destination.type = tile.type;
              destination.isMatched = false;
            }
          }

          emptyRow--;
        }
      }

      while (emptyRow >= 0) {
        final tile = board[emptyRow][col];

        if (!tile.isObstacle) {
          tile.isMatched = true;
        }

        emptyRow--;
      }
    }
  }

  static void refillBoard(
    List<List<GemTile>> board,
  ) {
    for (int row = 0;
        row < rows;
        row++) {
      for (int col = 0;
          col < columns;
          col++) {
        final tile = board[row][col];

        if (tile.isObstacle) {
          continue;
        }

        if (tile.isMatched) {
          tile.type = randomGem();
          tile.isMatched = false;
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

      totalScore += calculateScore(matches);

      // First damage Ice beside this match.
      damageAdjacentIce(
        board,
        matches,
      );

      // Then remove the matched gems.
      removeMatches(
        board,
        matches,
      );

      collapseBoard(board);
      refillBoard(board);
    }

    return totalScore;
  }
}

