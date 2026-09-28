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
  Offset? _tapDownPosition;

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
    }

    if (!widget.enabled) {
      _clearSelection();
      _gestureController.reset();
    }
  }

  void _createGestureController() {
    _gestureController = BoardGestureController(
      rows: widget.board.rows,
      columns: widget.board.columns,
      cellSize: widget.cellSize,
      dragThresholdFactor: 0.20,
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

  void _handleTapDown(
    TapDownDetails details,
  ) {
    if (!widget.enabled) {
      return;
    }

    _tapDownPosition = details.localPosition;
  }

  void _handleTap() {
    if (!widget.enabled) {
      return;
    }

    final localPosition = _tapDownPosition;

    _tapDownPosition = null;

    if (localPosition == null) {
      return;
    }

    final tappedPosition =
        _gestureController.positionFromOffset(
      localPosition,
    );

    if (tappedPosition == null) {
      _clearSelection();
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

  void _handleTapCancel() {
    _tapDownPosition = null;
  }

  void _handlePanStart(
    DragStartDetails details,
  ) {
    if (!widget.enabled) {
      return;
    }

    // A real drag has now won the gesture arena.
    // Tap handling is no longer needed for this pointer.
    _tapDownPosition = null;

    _gestureController.start(
      details.localPosition,
    );
  }

  void _handlePanUpdate(
    DragUpdateDetails details,
  ) {
    if (!widget.enabled) {
      return;
    }

    _gestureController.update(
      details.localPosition,
    );
  }

  void _handlePanEnd(
    DragEndDetails details,
  ) {
    if (!widget.enabled) {
      return;
    }

    _gestureController.end();
  }

  void _handlePanCancel() {
    _tapDownPosition = null;
    _gestureController.cancel();
  }

  void _setSelection(
    BoardPosition? position,
  ) {
    if (_selectedPosition == position) {
      return;
    }

    if (!mounted) {
      return;
    }

    if (position != null) {
      final cell = widget.board.cellAt(position);

      if (!cell.isAvailable || !cell.hasGem) {
        position = null;
      }
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

  @override
  void dispose() {
    _gestureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      dragStartBehavior: DragStartBehavior.down,
      onTapDown: _handleTapDown,
      onTap: _handleTap,
      onTapCancel: _handleTapCancel,
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      onPanCancel: _handlePanCancel,
      child: widget.child,
    );
  }
}
