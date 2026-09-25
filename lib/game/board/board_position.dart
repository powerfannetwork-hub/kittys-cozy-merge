import 'package:flutter/foundation.dart';

@immutable
class BoardPosition {
  const BoardPosition({
    required this.row,
    required this.column,
  });

  final int row;
  final int column;

  BoardPosition copyWith({
    int? row,
    int? column,
  }) {
    return BoardPosition(
      row: row ?? this.row,
      column: column ?? this.column,
    );
  }

  BoardPosition offset({
    required int rowOffset,
    required int columnOffset,
  }) {
    return BoardPosition(
      row: row + rowOffset,
      column: column + columnOffset,
    );
  }

  int get manhattanDistance => row.abs() + column.abs();

  bool isAdjacentTo(BoardPosition other) {
    return manhattanDistance == 1;
  }

  @override
  bool operator ==(Object other) {
    return other is BoardPosition &&
        other.row == row &&
        other.column == column;
  }

  @override
  int get hashCode => Object.hash(row, column);

  @override
  String toString() {
    return 'BoardPosition(row: $row, column: $column)';
  }
}
