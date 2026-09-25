import '../../models/gem_type.dart';
import '../board/board_position.dart';
import '../board/game_board.dart';
import '../gems/gem.dart';
import 'gem_swap.dart';
import 'match_detector.dart';
import 'match_result.dart';
import 'move_result.dart';
import 'swap_result.dart';

class GameEngine {
  GameEngine({
    required GameBoard board,
    required int moves,
    MatchDetector? matchDetector,
  })  : _board = board,
        _movesRemaining = moves,
        _matchDetector =
            matchDetector ?? const MatchDetector() {
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

    final resolution = _resolveMatches(
      preferredSpecialPosition: swap.to,
    );

    return SwapResult(
      status: SwapStatus.successful,
      from: swap.from,
      to: swap.to,
      matchedPositions:
          resolution.matchedPositions,
      cascadeCount:
          resolution.cascadeCount,
      scoreGained:
          resolution.scoreGained,
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
      matchedGemCount:
          result.matchedPositions.length,
      cascadeCount:
          result.cascadeCount,
      scoreGained:
          result.scoreGained,
    );
  }

  _ResolutionResult _resolveMatches({
    BoardPosition? preferredSpecialPosition,
  }) {
    final allMatchedPositions =
        <BoardPosition>{};

    int cascadeCount = 0;
    int scoreGained = 0;

    BoardPosition? specialPosition =
        preferredSpecialPosition;

    while (true) {
      final matchResult =
          _matchDetector.findMatches(_board);

      if (!matchResult.hasMatch) {
        break;
      }

      cascadeCount++;

      final matchedPositions =
          matchResult.positions;

      allMatchedPositions.addAll(
        matchedPositions,
      );

      final baseScore =
          matchedPositions.length * 10;

      final cascadeMultiplier =
          cascadeCount > 1
              ? cascadeCount
              : 1;

      final gained =
          baseScore * cascadeMultiplier;

      scoreGained += gained;
      _score += gained;

      final specialCreation =
          _selectSpecialCreation(
        matchResult,
        specialPosition,
      );

      if (specialCreation != null) {
        _createSpecialGem(
          position: specialCreation.position,
          type: specialCreation.type,
        );

        for (final position in matchedPositions) {
          if (position != specialCreation.position) {
            _removeGemIfAvailable(position);
          }
        }
      } else {
        _board.clearGems(
          matchedPositions,
        );
      }

      _board.applyGravity();

      _refillEmptyCells();

      specialPosition = null;
    }

    return _ResolutionResult(
      matchedPositions:
          allMatchedPositions,
      cascadeCount:
          cascadeCount,
      scoreGained:
          scoreGained,
    );
  }

  _SpecialCreation? _selectSpecialCreation(
    MatchResult matchResult,
    BoardPosition? preferredPosition,
  ) {
    final specialType =
        matchResult.specialMatchType;

    if (specialType == SpecialMatchType.none) {
      return null;
    }

    BoardPosition? position;

    if (preferredPosition != null &&
        matchResult.positions.contains(
          preferredPosition,
        )) {
      position = preferredPosition;
    } else {
      position = matchResult.specialGemPosition;
    }

    if (position == null) {
      return null;
    }

    final gemSpecialType =
        _toGemSpecialType(specialType);

    if (gemSpecialType == GemSpecialType.normal) {
      return null;
    }

    return _SpecialCreation(
      position: position,
      type: gemSpecialType,
    );
  }

  GemSpecialType _toGemSpecialType(
    SpecialMatchType type,
  ) {
    switch (type) {
      case SpecialMatchType.none:
        return GemSpecialType.normal;

      case SpecialMatchType.rocketHorizontal:
        return GemSpecialType.rocketHorizontal;

      case SpecialMatchType.rocketVertical:
        return GemSpecialType.rocketVertical;

      case SpecialMatchType.bomb:
        return GemSpecialType.bomb;

      case SpecialMatchType.colorBomb:
        return GemSpecialType.colorBomb;
    }
  }

  void _createSpecialGem({
    required BoardPosition position,
    required GemSpecialType type,
  }) {
    final existingGem =
        _board.gemAt(position);

    if (existingGem == null) {
      return;
    }

    _board.setGem(
      position,
      existingGem.copyWith(
        specialType: type,
      ),
    );
  }

  void _removeGemIfAvailable(
    BoardPosition position,
  ) {
    if (!_board.isInside(position)) {
      return;
    }

    final cell = _board.cellAt(position);

    if (cell.isAvailable) {
      _board.removeGem(position);
    }
  }

  void _refillEmptyCells() {
    final emptyPositions =
        _board.emptyPositions();

    for (final position in emptyPositions) {
      final type =
          _chooseRefillType(position);

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

  GemType _chooseRefillType(
    BoardPosition position,
  ) {
    final types = <GemType>[
      ..._availableGemTypes,
    ];

    types.shuffle();

    for (final type in types) {
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

    return types.first;
  }

  bool _createsImmediateHorizontalMatch(
    BoardPosition position,
    GemType type,
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
    GemType type,
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

  String _createGemId(
    BoardPosition position,
  ) {
    return 'gem_'
        '${DateTime.now().microsecondsSinceEpoch}_'
        '${position.row}_'
        '${position.column}';
  }

  static const List<GemType> _availableGemTypes =
      <GemType>[
    GemType.pink,
    GemType.blue,
    GemType.purple,
    GemType.green,
    GemType.yellow,
    GemType.orange,
  ];
}

class _SpecialCreation {
  const _SpecialCreation({
    required this.position,
    required this.type,
  });

  final BoardPosition position;

  final GemSpecialType type;
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
