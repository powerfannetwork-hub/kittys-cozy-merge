import '../../models/gem_type.dart';
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

    setCell(
      cell.copyWith(
        gemType: gem?.type,
        clearGem: gem == null,
      ),
    );
  }

  GemType? gemTypeAt(BoardPosition position) {
    return cellAt(position).gemType;
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
    if (!first.isAdjacentTo(second)) {
      throw ArgumentError(
        'Only adjacent cells can be swapped.',
      );
    }

    final firstCell = cellAt(first);
    final secondCell = cellAt(second);

    final firstGem = firstCell.gemType;
    final secondGem = secondCell.gemType;

    setCell(
      firstCell.copyWith(
        gemType: secondGem,
        clearGem: secondGem == null,
      ),
    );

    setCell(
      secondCell.copyWith(
        gemType: firstGem,
        clearGem: firstGem == null,
      ),
    );
  }

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
