import 'package:flutter/material.dart';

import 'board_gesture_controller.dart';
import 'board_position.dart';
import 'game_board.dart';
import '../gameplay/gem_swap.dart';

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

  void _setSelection(
    BoardPosition? position,
  ) {
    if (_selectedPosition == position) {
      return;
    }

    if (!mounted) {
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

  void _handlePanDown(
    DragDownDetails details,
  ) {
    if (!widget.enabled) {
      return;
    }

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
    _gestureController.cancel();
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
      onPanDown: _handlePanDown,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      onPanCancel: _handlePanCancel,
      child: widget.child,
    );
  }
}
