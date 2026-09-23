import 'package:flutter/material.dart';

import '../../models/gem_tile.dart';
import '../../services/board_service.dart';
import '../../services/lives_service.dart';
import 'lose_screen.dart';
import 'win_screen.dart';

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

class _GameScreenState extends State<GameScreen> {
  late List<List<GemTile>> board;

  GemTile? selectedTile;

  int score = 0;
  int moves = 30;
  int lives = 5;

  bool loading = true;
  bool canPlay = false;
  bool unlimitedLives = false;

  int get targetScore {
    return 500 + ((widget.level - 1) * 50);
  }

  @override
  void initState() {
    super.initState();
    _prepareGame();
  }

  Future<void> _prepareGame() async {
    final currentLives =
        await LivesService.refreshLives();

    final unlimited =
        await LivesService.isUnlimitedLives();

    if (!mounted) return;

    setState(() {
      lives = currentLives;
      unlimitedLives = unlimited;
    });

    final allowed =
        await LivesService.useLife();

    if (!mounted) return;

    if (!allowed) {
      setState(() {
        loading = false;
        canPlay = false;
      });
      return;
    }

    setState(() {
      lives = unlimited
          ? currentLives
          : currentLives - 1;

      loading = false;
      canPlay = true;
      board = BoardService.createBoard();
    });
  }

  void _checkGameState() {
    if (score >= targetScore) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => WinScreen(
            level: widget.level,
            score: score,
          ),
        ),
      );
      return;
    }

    if (moves <= 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LoseScreen(
            level: widget.level,
            score: score,
          ),
        ),
      );
    }
  }

  void _handleTap(
    int row,
    int column,
  ) {
    if (!canPlay || moves <= 0) return;

    final tappedTile = board[row][column];

    if (selectedTile == null) {
      setState(() {
        selectedTile = tappedTile;
      });
      return;
    }

    if (selectedTile == tappedTile) {
      setState(() {
        selectedTile = null;
      });
      return;
    }

    if (!BoardService.areAdjacent(
      selectedTile!,
      tappedTile,
    )) {
      setState(() {
        selectedTile = tappedTile;
      });
      return;
    }

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

      _checkGameState();
    } else {
      setState(() {
        selectedTile = null;
      });
    }
  }

  bool _isSelected(GemTile tile) {
    return selectedTile == tile;
  }

  String _formatLives() {
    if (unlimitedLives) {
      return '∞';
    }

    return '$lives/5';
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!canPlay) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Level ${widget.level}',
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 70,
                ),
                const SizedBox(height: 20),
                const Text(
                  'No Lives Left',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'You need a ❤️ to play this level.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    await LivesService.addLife();

                    final updatedLives =
                        await LivesService.refreshLives();

                    final unlimited =
                        await LivesService
                            .isUnlimitedLives();

                    if (!mounted) return;

                    if (updatedLives > 0 ||
                        unlimited) {
                      setState(() {
                        lives = updatedLives;
                        unlimitedLives = unlimited;
                        loading = true;
                      });

                      _prepareGame();
                    }
                  },
                  child: const Text(
                    'GET 1 ❤️',
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'BACK',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Level ${widget.level}',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 16,
            ),
            child: Center(
              child: Row(
                children: [
                  const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatLives(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
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

                const SizedBox(height: 10),

                LinearProgressIndicator(
                  value: (score / targetScore)
                      .clamp(0.0, 1.0),
                ),

                const SizedBox(height: 6),

                Text(
                  'Target: $targetScore',
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
                itemBuilder: (
                  context,
                  index,
                ) {
                  final row = index ~/ 8;
                  final col = index % 8;

                  final tile =
                      board[row][col];

                  final selected =
                      _isSelected(tile);

                  return GestureDetector(
                    onTap: () => _handleTap(
                      row,
                      col,
                    ),
                    child: AnimatedContainer(
                      duration:
                          const Duration(
                        milliseconds: 150,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? Colors.amber
                            : Colors.white,
                        border: Border.all(
                          color: selected
                              ? Colors.orange
                              : Colors.transparent,
                          width: 3,
                        ),
                        borderRadius:
                            BorderRadius.circular(
                          12,
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
