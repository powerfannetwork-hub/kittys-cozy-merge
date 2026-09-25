import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'board_position.dart';

typedef BoardGestureStartCallback = void Function(
  BoardPosition position,
);

typedef BoardGestureUpdateCallback = void Function(
  BoardPosition position,
);

typedef BoardGestureEndCallback = void Function(
  BoardPosition? start,
  BoardPosition? end,
);

class BoardGestureController {
  BoardGestureController({
    required this.rows,
    required this.columns,
    required this.cellSize,
    this.dragThresholdFactor = 0.28,
    this.onStart,
    this.onUpdate,
    this.onEnd,
  }) : assert(rows > 0),
       assert(columns > 0),
       assert(cellSize > 0),
       assert(dragThresholdFactor > 0);

  final int rows;
  final int columns;
  final double cellSize;

  final double dragThresholdFactor;

  final BoardGestureStartCallback? onStart;
  final BoardGestureUpdateCallback? onUpdate;
  final BoardGestureEndCallback? onEnd;

  BoardPosition? _startPosition;
  BoardPosition? _currentPosition;

  Offset? _startOffset;
  bool _hasStarted = false;

  BoardPosition? get startPosition => _startPosition;

  BoardPosition? get currentPosition => _currentPosition;

  bool get isActive => _hasStarted;

  void start(Offset localPosition) {
    final position = positionFromOffset(localPosition);

    if (position == null) {
      reset();
      return;
    }

    _startOffset = localPosition;
    _startPosition = position;
    _currentPosition = position;
    _hasStarted = true;

    onStart?.call(position);
  }

  void update(Offset localPosition) {
    if (!_hasStarted || _startOffset == null) {
      return;
    }

    final startOffset = _startOffset!;

    final delta = localPosition - startOffset;

    final minimumDistance =
        cellSize * dragThresholdFactor;

    if (delta.distance < minimumDistance) {
      return;
    }

    final targetPosition = _positionFromDrag(
      delta,
      _startPosition!,
    );

    if (targetPosition == null) {
      return;
    }

    if (targetPosition == _currentPosition) {
      return;
    }

    _currentPosition = targetPosition;

    onUpdate?.call(targetPosition);
  }

  void end() {
    if (!_hasStarted) {
      reset();
      return;
    }

    final start = _startPosition;
    final end = _currentPosition;

    onEnd?.call(
      start,
      end,
    );

    reset();
  }

  void cancel() {
    if (!_hasStarted) {
      reset();
      return;
    }

    final start = _startPosition;

    onEnd?.call(
      start,
      null,
    );

    reset();
  }

  BoardPosition? positionFromOffset(
    Offset offset,
  ) {
    if (offset.dx < 0 ||
        offset.dy < 0 ||
        offset.dx >= columns * cellSize ||
        offset.dy >= rows * cellSize) {
      return null;
    }

    final column =
        (offset.dx / cellSize).floor();

    final row =
        (offset.dy / cellSize).floor();

    if (!_isInsideBoard(row, column)) {
      return null;
    }

    return BoardPosition(
      row: row,
      column: column,
    );
  }

  BoardPosition? _positionFromDrag(
    Offset delta,
    BoardPosition start,
  ) {
    final absDx = delta.dx.abs();
    final absDy = delta.dy.abs();

    if (absDx < cellSize * dragThresholdFactor &&
        absDy < cellSize * dragThresholdFactor) {
      return null;
    }

    if (absDx >= absDy) {
      final columnOffset =
          delta.dx > 0 ? 1 : -1;

      final target = BoardPosition(
        row: start.row,
        column: start.column + columnOffset,
      );

      return _isInsideBoard(
        target.row,
        target.column,
      )
          ? target
          : null;
    }

    final rowOffset =
        delta.dy > 0 ? 1 : -1;

    final target = BoardPosition(
      row: start.row + rowOffset,
      column: start.column,
    );

    return _isInsideBoard(
      target.row,
      target.column,
    )
        ? target
        : null;
  }

  bool _isInsideBoard(
    int row,
    int column,
  ) {
    return row >= 0 &&
        row < rows &&
        column >= 0 &&
        column < columns;
  }

  void reset() {
    _startPosition = null;
    _currentPosition = null;
    _startOffset = null;
    _hasStarted = false;
  }

  @mustCallSuper
  void dispose() {
    reset();
  }
}
