import 'package:flutter/material.dart';

import '../../game/board/board_interaction_layer.dart';
import '../../game/board/board_widget.dart';
import '../../game/gameplay/gameplay_view_controller.dart';
import '../../game/gameplay/gem_swap.dart';

class GameplayBoardView extends StatelessWidget {
  const GameplayBoardView({
    super.key,
    required this.controller,
    required this.cellSize,
  });

  final GameplayViewController controller;
  final double cellSize;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final board = controller.session.board;

        final enabled =
            !controller.isProcessingMove &&
            controller.hasMovesRemaining &&
            !controller.isComplete;

        return BoardInteractionLayer(
          board: board,
          cellSize: cellSize,
          enabled: enabled,
          onSelectionChanged:
              controller.updateSelection,
          onSwap: (GemSwap swap) {
            controller.swap(
              swap.from,
              swap.to,
            );
          },
          child: BoardWidget(
            board: board,
            selectedPosition:
                controller.selectedPosition,
            enabled: enabled,
          ),
        );
      },
    );
  }
}
