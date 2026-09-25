import 'package:flutter/material.dart';

import '../../game/board/board_position.dart';
import '../../game/gems/gem.dart';
import '../../game/gameplay/gem_swap.dart';
import '../../game/gameplay/level_session.dart';
import '../../models/gem_type.dart';

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
  late final LevelSession _session;

  BoardPosition? _dragStart;
  Offset? _lastDragPosition;
  bool _processingMove = false;

  @override
  void initState() {
    super.initState();

    _session = LevelSession.create(
      levelNumber: widget.levelNumber,
    );
  }

  void _onPanStart(
    DragStartDetails details,
    double cellSize,
  ) {
    if (_processingMove ||
        !_session.hasMovesRemaining ||
        _session.isComplete) {
      return;
    }

    final position = _positionFromOffset(
      details.localPosition,
      cellSize,
    );

    if (position == null) {
      return;
    }

    final cell = _session.board.cells[
        position.row * _session.columns + position.column];

    if (!cell.isAvailable || !cell.hasGem) {
      return;
    }

    _dragStart = position;
    _lastDragPosition = details.localPosition;

    setState(() {});
  }

  void _onPanUpdate(
    DragUpdateDetails details,
  ) {
    if (_dragStart == null) {
      return;
    }

    _lastDragPosition = details.localPosition;
  }

  Future<void> _onPanEnd(
    DragEndDetails details,
    double cellSize,
  ) async {
    final start = _dragStart;
    final endOffset = _lastDragPosition;

    _dragStart = null;
    _lastDragPosition = null;

    if (start == null ||
        endOffset == null ||
        _processingMove) {
      setState(() {});
      return;
    }

    final end = _positionFromOffset(
      endOffset,
      cellSize,
    );

    if (end == null || !start.isAdjacentTo(end)) {
      setState(() {});
      return;
    }

    final targetCell = _session.board.cells[
        end.row * _session.columns + end.column];

    if (!targetCell.isAvailable ||
        !targetCell.hasGem) {
      setState(() {});
      return;
    }

    _processingMove = true;
    setState(() {});

    final result = _session.makeMove(
      GemSwap(
        from: start,
        to: end,
      ),
    );

    if (mounted) {
      setState(() {});
    }

    _processingMove = false;

    if (!mounted || result == null) {
      if (mounted) {
        setState(() {});
      }
      return;
    }

    if (_session.isComplete) {
      await _showCompleteDialog();
      return;
    }

    if (!_session.hasMovesRemaining) {
      await _showOutOfMovesDialog();
    }

    if (mounted) {
      setState(() {});
    }
  }

  BoardPosition? _positionFromOffset(
    Offset offset,
    double cellSize,
  ) {
    if (cellSize <= 0) {
      return null;
    }

    final column =
        (offset.dx / cellSize).floor();

    final row =
        (offset.dy / cellSize).floor();

    if (row < 0 ||
        row >= _session.rows ||
        column < 0 ||
        column >= _session.columns) {
      return null;
    }

    return BoardPosition(
      row: row,
      column: column,
    );
  }

  Future<void> _showCompleteDialog() async {
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
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
                'Score: ${_session.score}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Moves left: ${_session.movesRemaining}',
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
                Navigator.of(context).pop();
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
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
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
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text(
                'BACK TO MAP',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _restartLevel();
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
    setState(() {
      _session = LevelSession.create(
        levelNumber: widget.levelNumber,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildHud(),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final availableWidth =
                      constraints.maxWidth - 28;

                  final availableHeight =
                      constraints.maxHeight - 28;

                  final cellSize =
                      (availableWidth /
                              _session.columns)
                          .clamp(
                    1.0,
                    availableHeight /
                        _session.rows,
                  );

                  final boardWidth =
                      cellSize * _session.columns;

                  final boardHeight =
                      cellSize * _session.rows;

                  return Center(
                    child: _buildBoard(
                      cellSize,
                      boardWidth,
                      boardHeight,
                    ),
                  );
                },
              ),
            ),
            _buildHint(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        10,
        16,
        8,
      ),
      child: Row(
        children: [
          _GameHeaderButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'LEVEL ${_session.levelNumber}',
                  style: const TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF9C8792),
                  ),
                ),
                const Text(
                  'Cozy Challenge',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF342632),
                  ),
                ),
              ],
            ),
          ),
          _ScoreBadge(
            score: _session.score,
          ),
        ],
      ),
    );
  }

  Widget _buildHud() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        4,
        16,
        12,
      ),
      child: Row(
        children: [
          Expanded(
            child: _HudCard(
              icon: Icons.directions_run_rounded,
              label: 'MOVES',
              value: '${_session.movesRemaining}',
              color: const Color(0xFFFF68AA),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: _GoalsHud(
              session: _session,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoard(
    double cellSize,
    double boardWidth,
    double boardHeight,
  ) {
    return Container(
      width: boardWidth + 14,
      height: boardHeight + 14,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: const Color(0xFFEADCE6),
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            blurRadius: 24,
            offset: Offset(0, 12),
            color: Color(0x1A000000),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (details) {
            _onPanStart(
              details,
              cellSize,
            );
          },
          onPanUpdate: _onPanUpdate,
          onPanEnd: (details) {
            _onPanEnd(
              details,
              cellSize,
            );
          },
          child: SizedBox(
            width: boardWidth,
            height: boardHeight,
            child: Column(
              children: List.generate(
                _session.rows,
                (row) {
                  return Row(
                    children: List.generate(
                      _session.columns,
                      (column) {
                        return _buildCell(
                          row,
                          column,
                          cellSize,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCell(
    int row,
    int column,
    double cellSize,
  ) {
    final cell = _session.board.cells[
        row * _session.columns + column];

    final position = BoardPosition(
      row: row,
      column: column,
    );

    final selected = _dragStart == position;

    return SizedBox(
      width: cellSize,
      height: cellSize,
      child: Padding(
        padding: EdgeInsets.all(
          cellSize * 0.035,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: cell.hasHardObstacle
                ? const Color(0xFFD8CDD4)
                : const Color(0xFFF7EDF3),
            borderRadius: BorderRadius.circular(
              cellSize * 0.18,
            ),
            border: selected
                ? Border.all(
                    color: const Color(0xFFFF68AA),
                    width: 2.5,
                  )
                : null,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (cell.hasIce)
                Positioned.fill(
                  child: Container(
                    margin: EdgeInsets.all(
                      cellSize * 0.06,
                    ),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(
                        cellSize * 0.15,
                      ),
                      border: Border.all(
                        color: const Color(0xFF9EDFFF),
                        width: 2,
                      ),
                      color:
                          const Color(0x558EE6FF),
                    ),
                    child: Icon(
                      Icons.ac_unit_rounded,
                      size: cellSize * 0.35,
                      color:
                          const Color(0xAAFFFFFF),
                    ),
                  ),
                ),
              if (cell.hasBlock)
                Container(
                  width: cellSize * 0.68,
                  height: cellSize * 0.68,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(
                      cellSize * 0.16,
                    ),
                    gradient:
                        const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFE6DADF),
                        Color(0xFFB8AAB2),
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.grid_4x4_rounded,
                    size: cellSize * 0.34,
                    color: const Color(0xFF8C7C85),
                  ),
                ),
              if (cell.hasLockedTile)
                Container(
                  width: cellSize * 0.68,
                  height: cellSize * 0.68,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC8BBC3),
                    borderRadius:
                        BorderRadius.circular(
                      cellSize * 0.17,
                    ),
                  ),
                  child: Icon(
                    Icons.lock_rounded,
                    size: cellSize * 0.33,
                    color: Colors.white,
                  ),
                ),
              if (cell.gem != null)
                _GemWidget(
                  gem: cell.gem!,
                  size: cellSize * 0.73,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHint() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        5,
        18,
        16,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.swipe_rounded,
            size: 19,
            color: Color(0xFFB18E9E),
          ),
          const SizedBox(width: 7),
          Text(
            _processingMove
                ? 'Matching...'
                : 'Hold a gem, drag to a neighbor, release',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFF9B8792),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalsHud extends StatelessWidget {
  const _GoalsHud({
    required this.session,
  });

  final LevelSession session;

  @override
  Widget build(BuildContext context) {
    final goals = session.goals;

    return Container(
      height: 67,
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            blurRadius: 15,
            offset: Offset(0, 6),
            color: Color(0x10000000),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.flag_rounded,
            color: Color(0xFFF0B23E),
            size: 21,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              children: List.generate(
                goals.length,
                (index) {
                  final goal = goals[index];

                  return Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.only(
                        right:
                            index == goals.length - 1
                                ? 0
                                : 6,
                      ),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            goal.title,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style:
                                const TextStyle(
                              fontSize: 8,
                              fontWeight:
                                  FontWeight.w800,
                              color:
                                  Color(0xFF927E89),
                            ),
                          ),
                          const SizedBox(height: 3),
                          LinearProgressIndicator(
                            value: goal.progress,
                            minHeight: 5,
                            borderRadius:
                                BorderRadius.circular(
                              10,
                            ),
                            backgroundColor:
                                const Color(
                              0xFFF0E9ED,
                            ),
                            valueColor:
                                const AlwaysStoppedAnimation<
                                    Color>(
                              Color(0xFFFF68AA),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${goal.current}/${goal.target}',
                            style:
                                const TextStyle(
                              fontSize: 8,
                              fontWeight:
                                  FontWeight.w900,
                              color:
                                  Color(0xFF4C3945),
                            ),
                          ),
                        ],
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

class _HudCard extends StatelessWidget {
  const _HudCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 67,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            blurRadius: 15,
            offset: Offset(0, 6),
            color: Color(0x10000000),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 21,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 7,
              fontWeight: FontWeight.w800,
              color: Color(0xFFA18D98),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Color(0xFF342632),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({
    required this.score,
  });

  final int score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            blurRadius: 13,
            offset: Offset(0, 5),
            color: Color(0x10000000),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.star_rounded,
            color: Color(0xFFF1B43B),
            size: 19,
          ),
          const SizedBox(width: 5),
          Text(
            '$score',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: Color(0xFF342632),
            ),
          ),
        ],
      ),
    );
  }
}

class _GameHeaderButton extends StatelessWidget {
  const _GameHeaderButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            icon,
            color: const Color(0xFF705C69),
            size: 22,
          ),
        ),
      ),
    );
  }
}

class _GemWidget extends StatelessWidget {
  const _GemWidget({
    required this.gem,
    required this.size,
  });

  final Gem gem;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = _gemColors(gem.type);

    final special = gem.specialType;

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.08),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          size * 0.25,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: size * 0.13,
            offset: Offset(
              0,
              size * 0.07,
            ),
            color: const Color(0x33000000),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: size * 0.10,
            top: size * 0.08,
            child: Container(
              width: size * 0.20,
              height: size * 0.12,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.78),
                borderRadius:
                    BorderRadius.circular(20),
              ),
            ),
          ),
          Center(
            child: _specialIcon(
              special,
              size,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(
                  size * 0.18,
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.45),
                  width: 1.1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _specialIcon(
    GemSpecialType special,
    double size,
  ) {
    switch (special) {
      case GemSpecialType.normal:
        return const SizedBox.shrink();
      case GemSpecialType.rocketHorizontal:
        return Icon(
          Icons.arrow_forward_rounded,
          color: Colors.white.withOpacity(0.92),
          size: size * 0.43,
        );
      case GemSpecialType.rocketVertical:
        return Icon(
          Icons.arrow_upward_rounded,
          color: Colors.white.withOpacity(0.92),
          size: size * 0.43,
        );
      case GemSpecialType.bomb:
        return Icon(
          Icons.brightness_7_rounded,
          color: Colors.white.withOpacity(0.92),
          size: size * 0.42,
        );
      case GemSpecialType.colorBomb:
        return Icon(
          Icons.auto_awesome_rounded,
          color: Colors.white.withOpacity(0.94),
          size: size * 0.43,
        );
    }
  }

  List<Color> _gemColors(GemType type) {
    switch (type) {
      case GemType.pink:
        return const [
          Color(0xFFFFB8D8),
          Color(0xFFFF4B97),
          Color(0xFFD92F7C),
        ];
      case GemType.blue:
        return const [
          Color(0xFFB5F0FF),
          Color(0xFF3FADFF),
          Color(0xFF2378D4),
        ];
      case GemType.purple:
        return const [
          Color(0xFFE1C5FF),
          Color(0xFF955CF0),
          Color(0xFF6635B8),
        ];
      case GemType.green:
        return const [
          Color(0xFFB9F6CF),
          Color(0xFF42C975),
          Color(0xFF23904E),
        ];
      case GemType.yellow:
        return const [
          Color(0xFFFFF4A9),
          Color(0xFFFFCA31),
          Color(0xFFE39A0D),
        ];
      case GemType.orange:
        return const [
          Color(0xFFFFD5A8),
          Color(0xFFFF8944),
          Color(0xFFD95C20),
        ];
    }
  }
}
