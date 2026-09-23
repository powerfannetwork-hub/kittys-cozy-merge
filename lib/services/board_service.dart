import 'dart:math';

import '../models/gem_tile.dart';
import '../models/gem_type.dart';
import 'level_block_service.dart';
import 'level_obstacle_service.dart';

class BoardService {
  static const int rows = 8;
  static const int columns = 8;

  static final Random _random = Random();

  static GemType randomGem() {
    return GemType.values[
        _random.nextInt(GemType.values.length)];
  }

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

    while (findMatches(board).isNotEmpty) {
      final matches = findMatches(board);

      removeMatches(
        board,
        matches,
      );

      collapseBoard(board);
      refillBoard(board);
    }

    if (level >= 30 &&
        LevelObstacleService.shouldHaveIce(level)) {
      _addIce(
        board,
        level,
      );
    }

    if (level >= 60) {
      final blockCount =
          LevelBlockService.getBlockCount(level);

      if (blockCount > 0) {
        _addBlocks(
          board,
          level,
          blockCount,
        );
      }
    }

    return board;
  }

  static void _addIce(
    List<List<GemTile>> board,
    int level,
  ) {
    final iceCount =
        LevelObstacleService.getIceCount(level);

    if (iceCount <= 0) {
      return;
    }

    final iceHp =
        LevelObstacleService.getIceHp(level);

    final availablePositions = <GemTile>[];

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < columns; col++) {
        final tile = board[row][col];

        if (!tile.isObstacle) {
          availablePositions.add(tile);
        }
      }
    }

    availablePositions.shuffle(_random);

    for (int i = 0;
        i < iceCount &&
            i < availablePositions.length;
        i++) {
      final tile = availablePositions[i];

      tile.isObstacle = true;
      tile.iceHp = iceHp;
      tile.blockHp = 0;
      tile.isMatched = false;
    }
  }

  static void _addBlocks(
    List<List<GemTile>> board,
    int level,
    int blockCount,
  ) {
    final blockHp =
        LevelBlockService.getBlockHp(level);

    if (blockHp <= 0) {
      return;
    }

    final availablePositions = <GemTile>[];

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < columns; col++) {
        final tile = board[row][col];

        if (!tile.isObstacle) {
          availablePositions.add(tile);
        }
      }
    }

    availablePositions.shuffle(_random);

    for (int i = 0;
        i < blockCount &&
            i < availablePositions.length;
        i++) {
      final tile = availablePositions[i];

      tile.isObstacle = true;
      tile.blockHp = blockHp;
      tile.iceHp = 0;
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
    if (first.isObstacle ||
        second.isObstacle) {
      return false;
    }

    swapTiles(
      board,
      first,
      second,
    );

    final matches =
        findMatches(board);

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
        neighbors.add(
          board[row - 1][column],
        );
      }

      if (row < rows - 1) {
        neighbors.add(
          board[row + 1][column],
        );
      }

      if (column > 0) {
        neighbors.add(
          board[row][column - 1],
        );
      }

      if (column < columns - 1) {
        neighbors.add(
          board[row][column + 1],
        );
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

  static void damageAdjacentBlocks(
    List<List<GemTile>> board,
    List<GemTile> matches,
  ) {
    final blocksToDamage = <GemTile>{};

    for (final matchedTile in matches) {
      final row = matchedTile.row;
      final column = matchedTile.column;

      final neighbors = <GemTile>[];

      if (row > 0) {
        neighbors.add(
          board[row - 1][column],
        );
      }

      if (row < rows - 1) {
        neighbors.add(
          board[row + 1][column],
        );
      }

      if (column > 0) {
        neighbors.add(
          board[row][column - 1],
        );
      }

      if (column < columns - 1) {
        neighbors.add(
          board[row][column + 1],
        );
      }

      for (final neighbor in neighbors) {
        if (neighbor.isObstacle &&
            neighbor.blockHp > 0) {
          blocksToDamage.add(neighbor);
        }
      }
    }

    for (final block in blocksToDamage) {
      block.blockHp--;

      if (block.blockHp <= 0) {
        block.blockHp = 0;
        block.isObstacle = false;
        block.isMatched = true;
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

            if (!destination.isObstacle) {
              destination.type =
                  tile.type;

              destination.isMatched =
                  false;
            }
          }

          emptyRow--;
        }
      }

      while (emptyRow >= 0) {
        final tile =
            board[emptyRow][col];

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
      final matches =
          findMatches(board);

      if (matches.isEmpty) {
        break;
      }

      totalScore +=
          calculateScore(matches);

      damageAdjacentIce(
        board,
        matches,
      );

      damageAdjacentBlocks(
        board,
        matches,
      );

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
