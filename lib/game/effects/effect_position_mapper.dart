import 'package:flutter/material.dart';

import '../board/board_position.dart';

class EffectPositionMapper {
  EffectPositionMapper({
    required this.rows,
    required this.columns,
    required this.cellSize,
    this.origin = Offset.zero,
  }) : assert(rows > 0),
       assert(columns > 0),
       assert(cellSize > 0);

  final int rows;
  final int columns;
  final double cellSize;
  final Offset origin;

  Size get boardSize => Size(
        columns * cellSize,
        rows * cellSize,
      );

  Offset center(BoardPosition position) {
    _validatePosition(position);

    return Offset(
      origin.dx + (position.column * cellSize) + (cellSize / 2),
      origin.dy + (position.row * cellSize) + (cellSize / 2),
    );
  }

  Offset topLeft(BoardPosition position) {
    _validatePosition(position);

    return Offset(
      origin.dx + (position.column * cellSize),
      origin.dy + (position.row * cellSize),
    );
  }

  Offset bottomRight(BoardPosition position) {
    _validatePosition(position);

    return Offset(
      origin.dx + ((position.column + 1) * cellSize),
      origin.dy + ((position.row + 1) * cellSize),
    );
  }

  Rect rect(BoardPosition position) {
    return Rect.fromLTWH(
      topLeft(position).dx,
      topLeft(position).dy,
      cellSize,
      cellSize,
    );
  }

  BoardPosition positionFromOffset(Offset offset) {
    final localX = offset.dx - origin.dx;
    final localY = offset.dy - origin.dy;

    final column = (localX / cellSize).floor();
    final row = (localY / cellSize).floor();

    if (row < 0 ||
        row >= rows ||
        column < 0 ||
        column >= columns) {
      throw RangeError(
        'Offset $offset is outside the board bounds.',
      );
    }

    return BoardPosition(
      row: row,
      column: column,
    );
  }

  bool contains(BoardPosition position) {
    return position.row >= 0 &&
        position.row < rows &&
        position.column >= 0 &&
        position.column < columns;
  }

  bool containsOffset(Offset offset) {
    final localX = offset.dx - origin.dx;
    final localY = offset.dy - origin.dy;

    return localX >= 0 &&
        localY >= 0 &&
        localX < columns * cellSize &&
        localY < rows * cellSize;
  }

  Offset centerFromRowColumn({
    required int row,
    required int column,
  }) {
    return center(
      BoardPosition(
        row: row,
        column: column,
      ),
    );
  }

  List<Offset> centers(
    Iterable<BoardPosition> positions,
  ) {
    return positions
        .where(contains)
        .map(center)
        .toList(growable: false);
  }

  List<Rect> rects(
    Iterable<BoardPosition> positions,
  ) {
    return positions
        .where(contains)
        .map(rect)
        .toList(growable: false);
  }

  EffectPositionMapper copyWith({
    int? rows,
    int? columns,
    double? cellSize,
    Offset? origin,
  }) {
    return EffectPositionMapper(
      rows: rows ?? this.rows,
      columns: columns ?? this.columns,
      cellSize: cellSize ?? this.cellSize,
      origin: origin ?? this.origin,
    );
  }

  void _validatePosition(BoardPosition position) {
    if (!contains(position)) {
      throw RangeError(
        'Board position $position is outside the board bounds.',
      );
    }
  }
}
