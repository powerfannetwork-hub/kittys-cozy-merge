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
  State<GameScreen> createState() =>
      _GameScreenState();
}

class _GameScreenState
    extends State<GameScreen> {
  late List<List<GemTile>> board;

  int score = 0;

  int moves = 30;

  @override
  void initState() {
    super.initState();

    board = BoardService.createBoard();
  }

  void _handleTap(
    int row,
    int column,
  ) {
    final matches =
        BoardService.findMatches(board);

    if (matches.isNotEmpty) {
      setState(() {
        score +=
            BoardService.calculateScore(
          matches,
        );

        BoardService.removeMatches(
          board,
          matches,
        );

        moves--;
      });
    }
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
            padding:
                const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
              children: [
                Text(
                  'Score: $score',
                  style:
                      const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                Text(
                  'Moves: $moves',
                  style:
                      const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.all(
                12,
              ),
              child: GridView.builder(
                itemCount: 64,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemBuilder:
                    (context, index) {
                  final row =
                      index ~/ 8;

                  final col =
                      index % 8;

                  final tile =
                      board[row][col];

                  return GestureDetector(
                    onTap: () =>
                        _handleTap(
                      row,
                      col,
                    ),
                    child: Container(
                      decoration:
                          BoxDecoration(
                        color: Colors
                            .white,
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          tile.type
                              .emoji,
                          style:
                              const TextStyle(
                            fontSize:
                                26,
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
