import 'package:flutter/material.dart';

import '../../models/gem_tile.dart';
import '../../services/board_service.dart';

class GameScreen extends StatefulWidget {
  final int level;

  const GameScreen({
    super.key,
    required this.level,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<List<GemTile>> board;

  GemTile? selectedTile;

  int score = 0;
  int moves = 30;

  @override
  void initState() {
    super.initState();
    board = BoardService.createBoard();
  }

  void _handleTap(int row, int column) {
    if (moves <= 0) return;

    final tappedTile = board[row][column];

    // First selection
    if (selectedTile == null) {
      setState(() {
        selectedTile = tappedTile;
      });
      return;
    }

    // Same tile
    if (selectedTile == tappedTile) {
      setState(() {
        selectedTile = null;
      });
      return;
    }

    // Not adjacent
    if (!BoardService.areAdjacent(
      selectedTile!,
      tappedTile,
    )) {
      setState(() {
        selectedTile = tappedTile;
      });
      return;
    }

    // Try swap
    final success = BoardService.trySwap(
      board,
      selectedTile!,
      tappedTile,
    );

    if (success) {
      final gainedScore =
          BoardService.processBoard(board);

      setState(() {
        score += gainedScore;
        moves--;
        selectedTile = null;
      });
    } else {
      setState(() {
        selectedTile = null;
      });
    }
  }

  bool _isSelected(GemTile tile) {
    return selectedTile == tile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Level ${widget.level}',
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Score: $score',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Moves: $moves',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                itemCount: 64,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemBuilder: (context, index) {
                  final row = index ~/ 8;
                  final col = index % 8;

                  final tile = board[row][col];

                  final selected =
                      _isSelected(tile);

                  return GestureDetector(
                    onTap: () =>
                        _handleTap(row, col),
                    child: AnimatedContainer(
                      duration:
                          const Duration(
                        milliseconds: 150,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? Colors.amber
                            : Colors.white,
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                        border: Border.all(
                          color: selected
                              ? Colors.orange
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          tile.type.emoji,
                          style:
                              const TextStyle(
                            fontSize: 26,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
