import '../board/board_position.dart';
import '../board/game_board.dart';
import '../gems/gem.dart';
import 'board_generator.dart';
import 'gem_swap.dart';
import 'match_detector.dart';
import 'move_result.dart';
import 'swap_result.dart';

class GameEngine {
  GameEngine({
    required GameBoard board,
    required int moves,
    MatchDetector? matchDetector,
    BoardGenerator? boardGenerator,
  })  : _board = board,
        _movesRemaining = moves,
        _matchDetector =
            matchDetector ?? const MatchDetector(),
        _boardGenerator =
            boardGenerator ?? BoardGenerator() {
    if (moves < 0) {
      throw ArgumentError(
        'Moves cannot be negative.',
      );
    }
  }

  GameBoard _board;

  int _movesRemaining;

  int _score = 0;

  final MatchDetector _matchDetector;

  final BoardGenerator _boardGenerator;

  GameBoard get board => _board;

  int get movesRemaining => _movesRemaining;

  int get score => _score;

  bool get hasMovesRemaining => _movesRemaining > 0;

  SwapResult trySwap(GemSwap swap) {
    if (!swap.isAdjacent) {
      return SwapResult.invalid(
        from: swap.from,
        to: swap.to,
      );
    }

    if (!hasMovesRemaining) {
      return SwapResult.invalid(
        from: swap.from,
        to: swap.to,
      );
    }

    if (!_board.isInside(swap.from) ||
        !_board.isInside(swap.to)) {
      return SwapResult.invalid(
        from: swap.from,
        to: swap.to,
      );
    }

    if (!_board.canMoveTo(swap.from) ||
        !_board.canMoveTo(swap.to)) {
      return SwapResult.invalid(
        from: swap.from,
        to: swap.to,
      );
    }

    final firstGem = _board.gemAt(swap.from);
    final secondGem = _board.gemAt(swap.to);

    if (firstGem == null || secondGem == null) {
      return SwapResult.invalid(
        from: swap.from,
        to: swap.to,
      );
    }

    _board.swap(
      swap.from,
      swap.to,
    );

    final initialMatch =
        _matchDetector.findMatches(_board);

    if (!initialMatch.hasMatch) {
      _board.swap(
        swap.from,
        swap.to,
      );

      return SwapResult.noMatch(
        from: swap.from,
        to: swap.to,
      );
    }

    _movesRemaining--;

    final result = _resolveMatches();

    return SwapResult(
      status: SwapStatus.successful,
      from: swap.from,
      to: swap.to,
      matchedPositions: result.matchedPositions,
      cascadeCount: result.cascadeCount,
      scoreGained: result.scoreGained,
    );
  }

  MoveResult? makeMove(GemSwap swap) {
    final result = trySwap(swap);

    if (!result.isSuccessful) {
      return null;
    }

    return MoveResult(
      from: result.from,
      to: result.to,
      movesRemaining: _movesRemaining,
      matchedGemCount: result.matchedPositions.length,
      cascadeCount: result.cascadeCount,
      scoreGained: result.scoreGained,
    );
  }

  _ResolutionResult _resolveMatches() {
    final allMatchedPositions = <BoardPosition>{};

    int cascadeCount = 0;
    int scoreGained = 0;

    while (true) {
      final matchResult =
          _matchDetector.findMatches(_board);

      if (!matchResult.hasMatch) {
        break;
      }

      cascadeCount++;

      final matchedPositions = matchResult.positions;

      allMatchedPositions.addAll(
        matchedPositions,
      );

      final baseScore =
          matchedPositions.length * 10;

      final cascadeMultiplier =
          cascadeCount > 1 ? cascadeCount : 1;

      final gained =
          baseScore * cascadeMultiplier;

      scoreGained += gained;
      _score += gained;

      _board.clearGems(
        matchedPositions,
      );

      _board.applyGravity();

      _refillEmptyCells();
    }

    return _ResolutionResult(
      matchedPositions: allMatchedPositions,
      cascadeCount: cascadeCount,
      scoreGained: scoreGained,
    );
  }

  void _refillEmptyCells() {
    final emptyPositions =
        _board.emptyPositions();

    for (final position in emptyPositions) {
      final type = _chooseRefillType(
        position,
      );

      _board.setGem(
        position,
        Gem(
          id: _createGemId(position),
          type: type,
          position: position,
        ),
      );
    }
  }

  dynamic _chooseRefillType(
    BoardPosition position,
  ) {
    final types =
        BoardGenerator.availableGemTypes;

    final shuffled = List.of(types)
      ..shuffle();

    for (final type in shuffled) {
      if (!_createsImmediateHorizontalMatch(
        position,
        type,
      ) &&
          !_createsImmediateVerticalMatch(
        position,
        type,
      )) {
        return type;
      }
    }

    return shuffled.first;
  }

  bool _createsImmediateHorizontalMatch(
    BoardPosition position,
    dynamic type,
  ) {
    if (position.column < 2) {
      return false;
    }

    final first = BoardPosition(
      row: position.row,
      column: position.column - 1,
    );

    final second = BoardPosition(
      row: position.row,
      column: position.column - 2,
    );

    return _board.gemAt(first)?.type == type &&
        _board.gemAt(second)?.type == type;
  }

  bool _createsImmediateVerticalMatch(
    BoardPosition position,
    dynamic type,
  ) {
    if (position.row < 2) {
      return false;
    }

    final first = BoardPosition(
      row: position.row - 1,
      column: position.column,
    );

    final second = BoardPosition(
      row: position.row - 2,
      column: position.column,
    );

    return _board.gemAt(first)?.type == type &&
        _board.gemAt(second)?.type == type;
  }

  String _createGemId(BoardPosition position) {
    return 'gem_'
        '${DateTime.now().microsecondsSinceEpoch}_'
        '${position.row}_'
        '${position.column}';
  }
}

class _ResolutionResult {
  const _ResolutionResult({
    required this.matchedPositions,
    required this.cascadeCount,
    required this.scoreGained,
  });

  final Set<BoardPosition> matchedPositions;
  final int cascadeCount;
  final int scoreGained;
}
