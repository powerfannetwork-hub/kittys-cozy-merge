import 'package:flutter/material.dart';

import '../../models/gem_tile.dart';
import '../../models/gem_type.dart';
import '../../models/mission_data.dart';
import '../../services/board_service.dart';
import '../../services/lives_service.dart';
import '../../services/mission_factory.dart';
import '../lives/no_lives_screen.dart';
import 'lose_screen.dart';
import 'win_screen.dart';

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
  int lives = 5;

  bool loading = true;
  bool canPlay = false;
  bool unlimitedLives = false;
  late MissionData mission;
  int missionProgress = 0;

  int get targetScore {
    return 500 + ((widget.level - 1) * 50);
  }

  bool get hasIce {
    return widget.level >= 30;
  }

  bool get hasBlock {
    return widget.level >= 60;
  }

  bool get hasLockedTile {
    return widget.level >= 90;
  }

  @override
  void initState() {
    super.initState();
    _prepareGame();
  }

  Future<void> _prepareGame() async {
    final currentLives = await LivesService.refreshLives();

    final unlimited = await LivesService.isUnlimitedLives();

    if (!mounted) return;

    setState(() {
      lives = currentLives;
      unlimitedLives = unlimited;
    });

    final allowed = await LivesService.useLife();

    if (!mounted) return;

    if (!allowed) {
      setState(() {
        loading = false;
        canPlay = false;
      });

      _openNoLivesScreen();
      return;
    }

    final actualLives = await LivesService.getLives();

    if (!mounted) return;

    setState(() {
      lives = actualLives;
      unlimitedLives = unlimited;
      loading = false;
      canPlay = true;

      board = BoardService.createBoard(
        level: widget.level,
      );
      mission = MissionFactory.create(
        widget.level,
      );
    });
  }

  Future<void> _openNoLivesScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: () => const NoLivesScreen(),
      ),
    );

    if (!mounted) return;

    setState(() {
      loading = true;
    });

    await _prepareGame();
  }

  void _checkGameState() {
    if (score >= targetScore) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: () => WinScreen(
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
    if (!canPlay || moves <= 0) {
      return;
    }

    final tappedTile = board[row][column];

    if (tappedTile.isObstacle) {
      setState(() {
        selectedTile = null;
      });

      return;
    }

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

    if (tappedTile.isObstacle || selectedTile!.isObstacle) {
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
      final gainedScore = BoardService.processBoard(
        board,
      );

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

  String _getGemEmoji(
    GemType type,
  ) {
    switch (type) {
      case GemType.ruby:
        return '🔴';
      case GemType.sapphire:
        return '🔵';
      case GemType.emerald:
        return '🟢';
      case GemType.topaz:
        return '🟡';
      case GemType.amethyst:
        return '🟣';
      case GemType.diamond:
        return '💎';
    }
  }

  String _formatLives() {
    if (unlimitedLives) {
      return '∞';
    }

    return '$lives/5';
  }

  Widget _buildIceTile(
    GemTile tile,
  ) {
    final hp = tile.iceHp;

    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 250,
      ),
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hp <= 1? Colors.blue.shade700 : Colors.lightBlue.shade300,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            '🧊',
            style: TextStyle(
              fontSize: 27,
            ),
          ),
          Positioned(
            right: 3,
            top: 3,
            child: Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1.5,
                ),
              ),
              child: Text(
                '$hp',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockTile(
    GemTile tile,
  ) {
    final hp = tile.blockHp;

    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 250,
      ),
      decoration: BoxDecoration(
        color: Colors.brown.shade400,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hp <= 1? Colors.brown.shade900 : Colors.brown.shade600,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.30),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            '🧱',
            style: TextStyle(
              fontSize: 27,
            ),
          ),
          Positioned(
            right: 3,
            top: 3,
            child: Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.brown.shade900,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1.5,
                ),
              ),
              child: Text(
                '$hp',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockedTile(
    GemTile tile,
  ) {
    final hp = tile.lockedHp;

    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 250,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade700,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hp <= 1? Colors.black : Colors.grey.shade500,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.30),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            '🔒',
            style: TextStyle(
              fontSize: 27,
            ),
          ),
          Positioned(
            right: 3,
            top: 3,
            child: Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$hp',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNormalTile(
    GemTile tile,
    bool selected,
  ) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 150,
      ),
      decoration: BoxDecoration(
        color: selected? Colors.amber : Colors.white,
        border: Border.all(
          color: selected? Colors.orange : Colors.transparent,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Text(
          _getGemEmoji(
            tile.type,
          ),
          style: const TextStyle(
            fontSize: 26,
          ),
        ),
      ),
    );
  }

  Widget _buildTile(
    GemTile tile,
    bool selected,
  ) {
    if (tile.iceHp > 0) {
      return _buildIceTile(tile);
    }

    if (tile.blockHp > 0) {
      return _buildBlockTile(tile);
    }

    if (tile.lockedHp > 0) {
      return _buildLockedTile(tile);
    }

    return _buildNormalTile(
      tile,
      selected,
    );
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
        body: const Center(
          child: CircularProgressIndicator(),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  value: (score / targetScore).clamp(
                    0.0,
                    1.0,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.orange,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mission: ${mission.title}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Progress: $missionProgress / ${mission.target}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Target: $targetScore',
                    ),
                    if (hasIce)...[
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        '•',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        '🧊 Ice',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                    if (hasBlock)...[
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        '•',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        '🧱 Block',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ],
                    if (hasLockedTile)...[
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        '•',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        '🔒 Locked',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                itemCount: 64,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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

                  final tile = board[row][col];

                  final selected = _isSelected(tile);

                  return GestureDetector(
                    onTap: () => _handleTap(
                      row,
                      col,
                    ),
                    child: _buildTile(
                      tile,
                      selected,
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
