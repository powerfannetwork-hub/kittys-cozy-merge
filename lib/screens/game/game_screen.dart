import 'package:flutter/material.dart';

import '../../game/gameplay/gameplay_view_controller.dart';
import '../../game/gameplay/level_result_view_model.dart';
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
  late LevelResultViewModel _resultViewModel;

  bool _resultShown = false;

  @override
  void initState() {
    super.initState();

    _controller = GameplayViewController(
      session: LevelSession.create(
        levelNumber: widget.levelNumber,
      ),
      cellSize: 1,
    );

    _resultViewModel = LevelResultViewModel();

    _controller.addListener(_handleGameplayChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(
      _handleGameplayChanged,
    );

    _resultViewModel.dispose();
    _controller.dispose();

    super.dispose();
  }

  void _handleGameplayChanged() {
    if (!mounted || _resultShown) {
      return;
    }

    if (_controller.isComplete) {
      _resultShown = true;

      _resultViewModel.calculate(
        _controller.session,
      );

      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          if (mounted) {
            _showCompleteDialog();
          }
        },
      );

      return;
    }

    if (!_controller.hasMovesRemaining) {
      _resultShown = true;

      _resultViewModel.calculate(
        _controller.session,
      );

      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          if (mounted) {
            _showOutOfMovesDialog();
          }
        },
      );
    }
  }

  Future<void> _showCompleteDialog() async {
    if (!mounted) {
      return;
    }

    final result = _resultViewModel.requireResult();

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
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => Padding(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 3,
                    ),
                    child: Icon(
                      index < result.stars
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color:
                          const Color(0xFFFFB52E),
                      size: 30,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Score: ${result.score}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Moves left: ${result.movesRemaining}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF8F7D87),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Goals: ${result.completedGoals}/${result.totalGoals}',
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

    final result = _resultViewModel.requireResult();

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
          content: Text(
            'You ran out of moves before completing '
            'all goals.\n\n'
            'Goals: ${result.completedGoals}/'
            '${result.totalGoals}',
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

                _resultViewModel.clear();

                _resultShown = false;

                _controller.restart();

                if (mounted) {
                  setState(() {});
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFFFF68AA),
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
    _resultViewModel.clear();

    _resultShown = false;

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
                                offset:
                                    Offset(0, 12),
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
                            child:
                                GameplayBoardSurface(
                              controller:
                                  _controller,
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
