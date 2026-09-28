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

bool _dragging = false;
bool _swapSent = false;

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
  _resetPointer();
}

if (!widget.enabled) {
  _gestureController.reset();
  _clearSelection();
  _resetPointer();
}

}

void _createGestureController() {
_gestureController = BoardGestureController(
rows: widget.board.rows,
columns: widget.board.columns,
cellSize: widget.cellSize,
dragThresholdFactor: 0.12,
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

if (_swapSent) {
  return;
}

_swapSent = true;

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

_resetPointer();

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

if (_swapSent) {
  return;
}

final startOffset = _pointerDownOffset;
final startPosition = _pointerDownPosition;

if (startOffset == null ||
    startPosition == null) {
  return;
}

final delta =
    event.localPosition - startOffset;

final threshold =
    widget.cellSize * 0.10;

if (!_dragging &&
    delta.distance < threshold) {
  return;
}

_dragging = true;

final target =
    _getDragTarget(
  startPosition,
  delta,
);

if (target == null) {
  return;
}

if (!startPosition.isAdjacentTo(target)) {
  return;
}

if (!_isValidGemPosition(target)) {
  return;
}

_setSelection(target);

_swapSent = true;

final swap = GemSwap(
  from: startPosition,
  to: target,
);

_clearSelection();

widget.onSwap?.call(swap);

}

void _handlePointerUp(
PointerUpEvent event,
) {
if (!widget.enabled) {
_resetPointer();
return;
}

final start = _pointerDownPosition;

if (start == null) {
  _resetPointer();
  return;
}

if (_swapSent) {
  _resetPointer();
  return;
}

if (_dragging) {
  _resetPointer();
  return;
}

_handleTap(start);

_resetPointer();

}

void _handlePointerCancel(
PointerCancelEvent event,
) {
_gestureController.cancel();
_clearSelection();
_resetPointer();
}

void _handleTap(
BoardPosition tapped,
) {
if (!widget.enabled) {
return;
}

if (!_isValidGemPosition(tapped)) {
  return;
}

final selected = _selectedPosition;

if (selected == null) {
  _setSelection(tapped);
  return;
}

if (selected == tapped) {
  _clearSelection();
  return;
}

if (selected.isAdjacentTo(tapped)) {
  _swapSent = true;

  final swap = GemSwap(
    from: selected,
    to: tapped,
  );

  _clearSelection();

  widget.onSwap?.call(swap);
  return;
}

_setSelection(tapped);

}

BoardPosition? _getDragTarget(
BoardPosition start,
Offset delta,
) {
final absDx = delta.dx.abs();
final absDy = delta.dy.abs();

if (absDx < widget.cellSize * 0.10 &&
    absDy < widget.cellSize * 0.10) {
  return null;
}

late BoardPosition target;

if (absDx >= absDy) {
  target = BoardPosition(
    row: start.row,
    column: start.column +
        (delta.dx >= 0 ? 1 : -1),
  );
} else {
  target = BoardPosition(
    row: start.row +
        (delta.dy >= 0 ? 1 : -1),
    column: start.column,
  );
}

if (!widget.board.isInside(target)) {
  return null;
}

return target;

}

bool _isValidGemPosition(
BoardPosition position,
) {
if (!widget.board.isInside(position)) {
return false;
}

final cell =
    widget.board.cellAt(position);

return cell.isAvailable && cell.hasGem;

}

void _setSelection(
BoardPosition? position,
) {
if (!mounted) {
return;
}

if (position != null &&
    !_isValidGemPosition(position)) {
  position = null;
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

void _resetPointer() {
_pointerDownOffset = null;
_pointerDownPosition = null;
_dragging = false;
_swapSent = false;
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
