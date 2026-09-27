import 'package:flutter/material.dart';

import '../../game/board/board_interaction_layer.dart';
import '../../game/board/board_widget.dart';
import '../../game/gameplay/gameplay_view_controller.dart';
import '../../game/gameplay/gem_swap.dart';

class GameplayBoardSurface extends StatelessWidget {
  const GameplayBoardSurface({
    super.key,
    required this.controller,
    required this.cellSize,
  });

  final GameplayViewController controller;
  final double cellSize;

  double get boardWidth =>
      cellSize * controller.columns;

  double get boardHeight =>
      cellSize * controller.rows;

  @override
  Widget build(BuildContext context) {
    final board = controller.session.board;

    final enabled =
        !controller.isProcessingMove &&
        controller.hasMovesRemaining &&
        !controller.isComplete;

    return SizedBox(
      width: boardWidth,
      height: boardHeight,
      child: BoardInteractionLayer(
        board: board,
        cellSize: cellSize,
        enabled: enabled,
        onSelectionChanged:
            controller.updateSelection,
        onSwap: _handleSwap,
        child: BoardWidget(
          board: board,
          selectedPosition:
              controller.selectedPosition,
          enabled: enabled,
        ),
      ),
    );
  }

  void _handleSwap(
    GemSwap swap,
  ) {
    controller.swap(
      swap.from,
      swap.to,
    );
  }
}
