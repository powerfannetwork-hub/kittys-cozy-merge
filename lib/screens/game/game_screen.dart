import 'package:flutter/material.dart';

import '../../game/gameplay/gameplay_view_controller.dart';
import '../../game/gameplay/level_session.dart';
import 'gameplay_board_surface.dart';
import 'gameplay_hud.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.levelNumber,
  });

  final int levelNumber;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameplayViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = GameplayViewController(
      session: LevelSession.create(
        levelNumber: widget.levelNumber,
      ),
      cellSize: 1,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleMoveState() async {
    if (!mounted) {
      return;
    }

    if (_controller.isComplete) {
      await _showCompleteDialog();
      return;
    }

    if (!_controller.hasMovesRemaining) {
      await _showOutOfMovesDialog();
    }
  }

  Future<void> _showCompleteDialog() async {
    if (!mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27),
          ),
          title: const Text(
            'Level Complete!',
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFE7F2),
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: Color(0xFFFFB52E),
                  size: 42,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Score: ${_controller.score}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Moves left: ${_controller.movesRemaining}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF8F7D87),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
              },
              child: const Text(
                'BACK TO MAP',
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showOutOfMovesDialog() async {
    if (!mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27),
          ),
          title: const Text(
            'Out of Moves',
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
          content: const Text(
            'You ran out of moves before completing all goals.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
              },
              child: const Text(
                'BACK TO MAP',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();

                _controller.restart();

                if (mounted) {
                  setState(() {});
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF68AA),
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'TRY AGAIN',
              ),
            ),
          ],
        );
      },
    );
  }

  void _restartLevel() {
    _controller.restart();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FB),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            return Column(
              children: [
                GameplayHeader(
                  controller: _controller,
                  onBack: () {
                    Navigator.of(context).pop();
                  },
                ),
                GameplayHud(
                  controller: _controller,
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (
                      context,
                      constraints,
                    ) {
                      final availableWidth =
                          constraints.maxWidth - 28;

                      final availableHeight =
                          constraints.maxHeight - 28;

                      final cellSize =
                          (availableWidth /
                                  _controller.columns)
                              .clamp(
                                1.0,
                                availableHeight /
                                    _controller.rows,
                              )
                              .toDouble();

                      final boardWidth =
                          cellSize *
                              _controller.columns;

                      final boardHeight =
                          cellSize *
                              _controller.rows;

                      return Center(
                        child: Container(
                          width: boardWidth + 14,
                          height: boardHeight + 14,
                          padding:
                              const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFEADCE6),
                            borderRadius:
                                BorderRadius.circular(
                              25,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 24,
                                offset: Offset(0, 12),
                                color:
                                    Color(0x1A000000),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(
                              19,
                            ),
                            child: GameplayBoardSurface(
                              controller: _controller,
                              cellSize: cellSize,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                GameplayHint(
                  controller: _controller,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
