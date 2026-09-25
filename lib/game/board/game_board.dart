import 'package:flutter/foundation.dart';

import '../gems/gem.dart';
import 'board_cell.dart';
import 'board_position.dart';

class GameBoard {
  GameBoard({
    required this.rows,
    required this.columns,
    List<List<BoardCell>>? cells,
  }) : _cells = cells ?? _createEmptyCells(rows, columns);

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

  void setCell(BoardCell cell) {
    if (!isInside(cell.position)) {
      throw RangeError(
        'Board position is outside the board: ${cell.position}',
      );
    }

    _cells[cell.position.row][cell.position.column] = cell;
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
    setCell(cell.removeGem());
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
    if (!isInside(first) || !isInside(second)) {
      throw RangeError(
        'Cannot swap positions outside the board.',
      );
    }

    if (!first.isAdjacentTo(second)) {
      throw ArgumentError(
        'Only adjacent cells can be swapped.',
      );
    }

    final firstCell = cellAt(first);
    final secondCell = cellAt(second);

    final firstGem = firstCell.gem;
    final secondGem = secondCell.gem;

    setGem(first, secondGem);
    setGem(second, firstGem);
  }

  void clearGems(Iterable<BoardPosition> positions) {
    for (final position in positions) {
      if (isInside(position)) {
        removeGem(position);
      }
    }
  }

  List<BoardPosition> emptyPositions() {
    final result = <BoardPosition>[];

    for (int row = 0; row < rows; row++) {
      for (int column = 0; column < columns; column++) {
        final position = BoardPosition(
          row: row,
          column: column,
        );

        if (!cellAt(position).hasGem &&
            cellAt(position).isAvailable) {
          result.add(position);
        }
      }
    }

    return result;
  }

  @visibleForTesting
  List<List<BoardCell>> get mutableCells => _cells;

  static List<List<BoardCell>> _createEmptyCells(
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
