import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../gameplay/gem_swap.dart';
import 'board_gesture_controller.dart';
import 'board_position.dart';
import 'game_board.dart';

typedef BoardSwapCallback = void Function(
GemSwap swap,
);

typedef BoardSelectionCallback = void Function(
BoardPosition? position,
);

class BoardInteractionLayer extends StatefulWidget {
const BoardInteractionLayer({
super.key,
required this.board,
required this.cellSize,
required this.child,
this.enabled = true,
this.onSwap,
this.onSelectionChanged,
});

final GameBoard board;
final double cellSize;
final Widget child;
final bool enabled;

final BoardSwapCallback? onSwap;
final BoardSelectionCallback? onSelectionChanged;

@override
State<BoardInteractionLayer> createState() =>
_BoardInteractionLayerState();
}

class _BoardInteractionLayerState
extends State<BoardInteractionLayer> {
late BoardGestureController _gestureController;

BoardPosition? _selectedPosition;

Offset? _pointerDownOffset;
BoardPosition? _pointerDownPosition;

BoardPosition? _dragTarget;
bool _isDragging = false;

@override
void initState() {
super.initState();
_createGestureController();
}

@override
void didUpdateWidget(
covariant BoardInteractionLayer oldWidget,
) {
super.didUpdateWidget(oldWidget);

final dimensionsChanged =
    oldWidget.board.rows != widget.board.rows ||
    oldWidget.board.columns != widget.board.columns ||
    oldWidget.cellSize != widget.cellSize;

if (dimensionsChanged) {
  _gestureController.dispose();
  _createGestureController();
  _resetPointerState();
}

if (!widget.enabled) {
  _clearSelection();
  _gestureController.reset();
  _resetPointerState();
}

}

void _createGestureController() {
_gestureController = BoardGestureController(
rows: widget.board.rows,
columns: widget.board.columns,
cellSize: widget.cellSize,
dragThresholdFactor: 0.16,
onStart: _handleGestureStart,
onUpdate: _handleGestureUpdate,
onEnd: _handleGestureEnd,
);
}

void _handleGestureStart(
BoardPosition position,
) {
if (!widget.enabled) {
return;
}

_setSelection(position);

}

void _handleGestureUpdate(
BoardPosition position,
) {
if (!widget.enabled) {
return;
}

_setSelection(position);

}

void _handleGestureEnd(
BoardPosition? start,
BoardPosition? end,
) {
if (!widget.enabled) {
_clearSelection();
return;
}

if (start == null || end == null) {
  _clearSelection();
  return;
}

if (start == end) {
  _clearSelection();
  return;
}

if (!start.isAdjacentTo(end)) {
  _clearSelection();
  return;
}

final swap = GemSwap(
  from: start,
  to: end,
);

_clearSelection();

widget.onSwap?.call(swap);

}

void _handlePointerDown(
PointerDownEvent event,
) {
if (!widget.enabled) {
return;
}

_resetPointerState();

final position =
    _gestureController.positionFromOffset(
  event.localPosition,
);

if (position == null) {
  return;
}

final cell = widget.board.cellAt(position);

if (!cell.isAvailable || !cell.hasGem) {
  return;
}

_pointerDownOffset = event.localPosition;
_pointerDownPosition = position;

_setSelection(position);

}

void _handlePointerMove(
PointerMoveEvent event,
) {
if (!widget.enabled) {
return;
}

final startOffset = _pointerDownOffset;
final startPosition = _pointerDownPosition;

if (startOffset == null || startPosition == null) {
  return;
}

final delta =
    event.localPosition - startOffset;

final dragThreshold =
    widget.cellSize * 0.12;

if (!_isDragging &&
    delta.distance < dragThreshold) {
  return;
}

_isDragging = true;

final target =
    _targetFromDelta(
  startPosition,
  delta,
);

if (target == null) {
  return;
}

if (!target.isAdjacentTo(startPosition)) {
  return;
}

final targetCell =
    widget.board.cellAt(target);

if (!targetCell.isAvailable ||
    !targetCell.hasGem) {
  return;
}

_dragTarget = target;

_setSelection(target);

}

void _handlePointerUp(
PointerUpEvent event,
) {
if (!widget.enabled) {
_resetPointerState();
return;
}

final start = _pointerDownPosition;
final dragTarget = _dragTarget;
final wasDragging = _isDragging;

if (start == null) {
  _resetPointerState();
  return;
}

if (wasDragging) {
  if (dragTarget != null &&
      start.isAdjacentTo(dragTarget)) {
    final swap = GemSwap(
      from: start,
      to: dragTarget,
    );

    _clearSelection();
    _resetPointerState();

    widget.onSwap?.call(swap);
    return;
  }

  _resetPointerState();
  return;
}

_handleTapSelection(start);

_resetPointerState();

}

void _handlePointerCancel(
PointerCancelEvent event,
) {
_gestureController.cancel();
_resetPointerState();
}

void _handleTapSelection(
BoardPosition tappedPosition,
) {
if (!widget.enabled) {
return;
}

final cell =
    widget.board.cellAt(tappedPosition);

if (!cell.isAvailable || !cell.hasGem) {
  return;
}

final selected = _selectedPosition;

if (selected == null) {
  _setSelection(tappedPosition);
  return;
}

if (selected == tappedPosition) {
  _clearSelection();
  return;
}

if (selected.isAdjacentTo(tappedPosition)) {
  final swap = GemSwap(
    from: selected,
    to: tappedPosition,
  );

  _clearSelection();

  widget.onSwap?.call(swap);
  return;
}

_setSelection(tappedPosition);

}

BoardPosition? _targetFromDelta(
BoardPosition start,
Offset delta,
) {
final absDx = delta.dx.abs();
final absDy = delta.dy.abs();

if (absDx < widget.cellSize * 0.12 &&
    absDy < widget.cellSize * 0.12) {
  return null;
}

if (absDx >= absDy) {
  final columnOffset =
      delta.dx >= 0 ? 1 : -1;

  final target = BoardPosition(
    row: start.row,
    column:
        start.column + columnOffset,
  );

  if (!_isInsideBoard(target)) {
    return null;
  }

  return target;
}

final rowOffset =
    delta.dy >= 0 ? 1 : -1;

final target = BoardPosition(
  row: start.row + rowOffset,
  column: start.column,
);

if (!_isInsideBoard(target)) {
  return null;
}

return target;

}

bool _isInsideBoard(
BoardPosition position,
) {
return widget.board.isInside(position);
}

void _setSelection(
BoardPosition? position,
) {
if (!mounted) {
return;
}

if (position != null) {
  if (!widget.board.isInside(position)) {
    position = null;
  } else {
    final cell =
        widget.board.cellAt(position);

    if (!cell.isAvailable ||
        !cell.hasGem) {
      position = null;
    }
  }
}

if (_selectedPosition == position) {
  return;
}

setState(() {
  _selectedPosition = position;
});

widget.onSelectionChanged?.call(position);

}

void _clearSelection() {
if (!mounted) {
_selectedPosition = null;
widget.onSelectionChanged?.call(null);
return;
}

if (_selectedPosition == null) {
  return;
}

setState(() {
  _selectedPosition = null;
});

widget.onSelectionChanged?.call(null);

}

void _resetPointerState() {
_pointerDownOffset = null;
_pointerDownPosition = null;
_dragTarget = null;
_isDragging = false;
}

@override
void dispose() {
_gestureController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
return Listener(
behavior: HitTestBehavior.opaque,
onPointerDown: _handlePointerDown,
onPointerMove: _handlePointerMove,
onPointerUp: _handlePointerUp,
onPointerCancel: _handlePointerCancel,
child: widget.child,
);
}
}
