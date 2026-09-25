import 'package:flutter/foundation.dart';

import '../gems/gem.dart';
import 'board_cell.dart';
import 'board_position.dart';

class GameBoard {
  GameBoard({
    required this.rows,
    required this.columns,
    List<List<BoardCell>>? cells,
  }) : _cells =
            cells ?? _createEmptyCells(rows, columns);

  final int rows;

  final int columns;

  final List<List<BoardCell>> _cells;

  List<List<BoardCell>> get cells {
    return List.unmodifiable(
      _cells.map(
        (row) => List<BoardCell>.unmodifiable(row),
      ),
    );
  }

  bool isInside(BoardPosition position) {
    return position.row >= 0 &&
        position.row < rows &&
        position.column >= 0 &&
        position.column < columns;
  }

  BoardCell cellAt(BoardPosition position) {
    if (!isInside(position)) {
      throw RangeError(
        'Board position is outside the board: $position',
      );
    }

    return _cells[position.row][position.column];
  }

  Gem? gemAt(BoardPosition position) {
    return cellAt(position).gem;
  }

  bool hasObstacleAt(BoardPosition position) {
    return cellAt(position).hasObstacle;
  }

  bool hasIceAt(BoardPosition position) {
    return cellAt(position).hasIce;
  }

  bool hasBlockAt(BoardPosition position) {
    return cellAt(position).hasBlock;
  }

  bool hasLockedTileAt(BoardPosition position) {
    return cellAt(position).hasLockedTile;
  }

  int iceLayersAt(BoardPosition position) {
    return cellAt(position).iceLayers;
  }

  void setCell(BoardCell cell) {
    if (!isInside(cell.position)) {
      throw RangeError(
        'Board position is outside the board: '
        '${cell.position}',
      );
    }

    _cells[cell.position.row][cell.position.column] =
        cell;
  }

  void setGem(
    BoardPosition position,
    Gem? gem,
  ) {
    final cell = cellAt(position);

    final updatedGem = gem?.copyWith(
      position: position,
    );

    setCell(
      cell.copyWith(
        gem: updatedGem,
        clearGem: updatedGem == null,
      ),
    );
  }

  void removeGem(BoardPosition position) {
    final cell = cellAt(position);

    setCell(
      cell.removeGem(),
    );
  }

  void damageIce(BoardPosition position) {
    if (!isInside(position)) {
      return;
    }

    final cell = cellAt(position);

    if (!cell.hasIce) {
      return;
    }

    setCell(
      cell.damageIce(),
    );
  }

  void damageIceAtPositions(
    Iterable<BoardPosition> positions,
  ) {
    for (final position in positions) {
      damageIce(position);
    }
  }

  void unlockTile(BoardPosition position) {
    if (!isInside(position)) {
      return;
    }

    final cell = cellAt(position);

    if (!cell.hasLockedTile) {
      return;
    }

    setCell(
      cell.unlock(),
    );
  }

  void unlockTiles(
    Iterable<BoardPosition> positions,
  ) {
    for (final position in positions) {
      unlockTile(position);
    }
  }

  void removeObstacle(BoardPosition position) {
    if (!isInside(position)) {
      return;
    }

    final cell = cellAt(position);

    if (!cell.hasObstacle) {
      return;
    }

    setCell(
      cell.removeObstacle(),
    );
  }

  void setIce(
    BoardPosition position,
    int layers,
  ) {
    if (!isInside(position)) {
      return;
    }

    final cell = cellAt(position);

    setCell(
      cell.withIce(layers),
    );
  }

  void setBlock(BoardPosition position) {
    if (!isInside(position)) {
      return;
    }

    final cell = cellAt(position);

    setCell(
      cell.withBlock(),
    );
  }

  void setLockedTile(
    BoardPosition position,
  ) {
    if (!isInside(position)) {
      return;
    }

    final cell = cellAt(position);

    setCell(
      cell.withLockedTile(),
    );
  }

  bool canMoveTo(BoardPosition position) {
    if (!isInside(position)) {
      return false;
    }

    return cellAt(position).isAvailable;
  }

  Iterable<BoardPosition> adjacentPositions(
    BoardPosition position,
  ) sync* {
    const directions = <List<int>>[
      [-1, 0],
      [1, 0],
      [0, -1],
      [0, 1],
    ];

    for (final direction in directions) {
      final next = position.offset(
        rowOffset: direction[0],
        columnOffset: direction[1],
      );

      if (isInside(next)) {
        yield next;
      }
    }
  }

  void swap(
    BoardPosition first,
    BoardPosition second,
  ) {
    if (!isInside(first) ||
        !isInside(second)) {
      throw RangeError(
        'Cannot swap positions outside the board.',
      );
    }

    if (!first.isAdjacentTo(second)) {
      throw ArgumentError(
        'Only adjacent cells can be swapped.',
      );
    }

    if (!canMoveTo(first) ||
        !canMoveTo(second)) {
      throw StateError(
        'Blocked cells cannot be swapped.',
      );
    }

    final firstGem = gemAt(first);
    final secondGem = gemAt(second);

    setGem(first, secondGem);
    setGem(second, firstGem);
  }

  void clearGems(
    Iterable<BoardPosition> positions,
  ) {
    for (final position in positions) {
      if (!isInside(position)) {
        continue;
      }

      final cell = cellAt(position);

      if (cell.isAvailable) {
        removeGem(position);
      }
    }
  }

  List<BoardPosition> emptyPositions() {
    final result = <BoardPosition>[];

    for (int row = 0; row < rows; row++) {
      for (int column = 0;
          column < columns;
          column++) {
        final position = BoardPosition(
          row: row,
          column: column,
        );

        final cell = cellAt(position);

        if (cell.isAvailable &&
            !cell.hasGem) {
          result.add(position);
        }
      }
    }

    return result;
  }

  void applyGravity() {
    for (int column = 0;
        column < columns;
        column++) {
      int targetRow = rows - 1;

      for (int row = rows - 1;
          row >= 0;
          row--) {
        final position = BoardPosition(
          row: row,
          column: column,
        );

        final cell = cellAt(position);

        if (!cell.isAvailable) {
          targetRow = row - 1;
          continue;
        }

        final gem = cell.gem;

        if (gem == null) {
          continue;
        }

        while (targetRow >= 0) {
          final targetPosition =
              BoardPosition(
            row: targetRow,
            column: column,
          );

          final targetCell =
              cellAt(targetPosition);

          if (targetCell.isAvailable) {
            break;
          }

          targetRow--;
        }

        if (targetRow < 0) {
          break;
        }

        final targetPosition = BoardPosition(
          row: targetRow,
          column: column,
        );

        if (row != targetRow) {
          setGem(position, null);
          setGem(targetPosition, gem);
        }

        targetRow--;
      }
    }
  }

  @visibleForTesting
  List<List<BoardCell>> get mutableCells =>
      _cells;

  static List<List<BoardCell>>
      _createEmptyCells(
    int rows,
    int columns,
  ) {
    if (rows <= 0 || columns <= 0) {
      throw ArgumentError(
        'Board rows and columns must be greater than zero.',
      );
    }

    return List.generate(
      rows,
      (row) => List.generate(
        columns,
        (column) => BoardCell(
          position: BoardPosition(
            row: row,
            column: column,
          ),
        ),
      ),
    );
  }
}
