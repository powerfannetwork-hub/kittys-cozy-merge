import '../../models/gem_type.dart';
import '../board/board_position.dart';
import '../board/game_board.dart';
import '../gems/gem.dart';
import 'gem_swap.dart';
import 'level_goal_tracker.dart';
import 'match_detector.dart';
import 'match_result.dart';
import 'move_result.dart';
import 'swap_result.dart';

class GameEngine {
  GameEngine({
    required GameBoard board,
    required int moves,
    LevelGoalTracker? goalTracker,
    MatchDetector? matchDetector,
  })  : _board = board,
        _movesRemaining = moves,
        _goalTracker = goalTracker,
        _matchDetector = matchDetector ?? const MatchDetector() {
    if (moves < 0) {
      throw ArgumentError(
        'Moves cannot be negative.',
      );
    }
  }

  GameBoard _board;

  int _movesRemaining;

  int _score = 0;

  final LevelGoalTracker? _goalTracker;

  final MatchDetector _matchDetector;

  GameBoard get board => _board;

  int get movesRemaining => _movesRemaining;

  int get score => _score;

  LevelGoalTracker? get goalTracker => _goalTracker;

  bool get hasMovesRemaining => _movesRemaining > 0;

  bool get isLevelComplete =>
      _goalTracker?.isComplete ?? false;

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

    if (firstGem.isSpecial || secondGem.isSpecial) {
      _movesRemaining--;

      final resolution = _resolveSpecialSwap(
        firstPosition: swap.to,
        secondPosition: swap.from,
      );

      return SwapResult(
        status: SwapStatus.successful,
        from: swap.from,
        to: swap.to,
        matchedPositions: resolution.matchedPositions,
        cascadeCount: resolution.cascadeCount,
        scoreGained: resolution.scoreGained,
      );
    }

    final initialMatch = _matchDetector.findMatches(_board);

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
      matchedPositions: resolution.matchedPositions,
      cascadeCount: resolution.cascadeCount,
      scoreGained: resolution.scoreGained,
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

  _ResolutionResult _resolveSpecialSwap({
    required BoardPosition firstPosition,
    required BoardPosition secondPosition,
  }) {
    final firstGem = _board.gemAt(firstPosition);

    final secondGem = _board.gemAt(secondPosition);

    if (firstGem == null || secondGem == null) {
      return const _ResolutionResult(
        matchedPositions: <BoardPosition>{},
        cascadeCount: 0,
        scoreGained: 0,
      );
    }

    final matchedPositions = <BoardPosition>{};

    int scoreGained = 0;

    if (firstGem.specialType == GemSpecialType.colorBomb &&
        secondGem.specialType == GemSpecialType.colorBomb) {
      final positions = _allAvailableGemPositions();

      matchedPositions.addAll(positions);

      scoreGained += _clearPositions(positions);

      return _finishSpecialResolution(
        matchedPositions: matchedPositions,
        scoreGained: scoreGained,
      );
    }

    if (firstGem.specialType == GemSpecialType.colorBomb ||
        secondGem.specialType == GemSpecialType.colorBomb) {
      final colorBomb =
          firstGem.specialType == GemSpecialType.colorBomb
              ? firstGem
              : secondGem;

      final otherGem =
          identical(colorBomb, firstGem) ? secondGem : firstGem;

      final positions = _activateColorBombWithSpecial(
        colorBomb: colorBomb,
        special: otherGem,
      );

      matchedPositions.addAll(positions);

      scoreGained += _clearPositions(positions);

      return _finishSpecialResolution(
        matchedPositions: matchedPositions,
        scoreGained: scoreGained,
      );
    }

    if (_isRocket(firstGem) && _isRocket(secondGem)) {
      final positions = _rocketPlusRocketPositions(
        firstPosition,
        secondPosition,
      );

      matchedPositions.addAll(positions);

      scoreGained += _clearPositions(positions);

      return _finishSpecialResolution(
        matchedPositions: matchedPositions,
        scoreGained: scoreGained,
      );
    }

    if (firstGem.specialType == GemSpecialType.bomb &&
        secondGem.specialType == GemSpecialType.bomb) {
      final positions = _bombPlusBombPositions(
        firstPosition,
        secondPosition,
      );

      matchedPositions.addAll(positions);

      scoreGained += _clearPositions(positions);

      return _finishSpecialResolution(
        matchedPositions: matchedPositions,
        scoreGained: scoreGained,
      );
    }

    if ((_isRocket(firstGem) &&
            secondGem.specialType == GemSpecialType.bomb) ||
        (_isRocket(secondGem) &&
            firstGem.specialType == GemSpecialType.bomb)) {
      final rocket = _isRocket(firstGem) ? firstGem : secondGem;

      final rocketPosition =
          identical(rocket, firstGem) ? firstPosition : secondPosition;

      final positions = _rocketPlusBombPositions(
        rocketPosition,
      );

      matchedPositions.addAll(positions);

      scoreGained += _clearPositions(positions);

      return _finishSpecialResolution(
        matchedPositions: matchedPositions,
        scoreGained: scoreGained,
      );
    }

    final specialGem = firstGem.isSpecial ? firstGem : secondGem;

    final specialPosition =
        firstGem.isSpecial ? firstPosition : secondPosition;

    final targetGem =
        firstGem.isSpecial ? secondGem : firstGem;

    final positions = _activateSpecial(
      position: specialPosition,
      specialGem: specialGem,
      targetType: targetGem.type,
    );

    matchedPositions.addAll(positions);

    scoreGained += _clearPositions(positions);

    return _finishSpecialResolution(
      matchedPositions: matchedPositions,
      scoreGained: scoreGained,
    );
  }

  _ResolutionResult _resolveMatches({
    BoardPosition? preferredSpecialPosition,
  }) {
    final allMatchedPositions = <BoardPosition>{};

    int cascadeCount = 0;
    int scoreGained = 0;

    BoardPosition? specialPosition = preferredSpecialPosition;

    while (true) {
      final matchResult = _matchDetector.findMatches(_board);

      if (!matchResult.hasMatch) {
        break;
      }

      cascadeCount++;

      final matchedPositions = matchResult.positions;

      allMatchedPositions.addAll(matchedPositions);

      final baseScore = matchedPositions.length * 10;

      final cascadeMultiplier =
          cascadeCount > 1 ? cascadeCount : 1;

      final gained = baseScore * cascadeMultiplier;

      scoreGained += gained;
      _score += gained;

      _goalTracker?.addScore(gained);

      final specialCreation = _selectSpecialCreation(
        matchResult,
        specialPosition,
      );

      if (specialCreation != null) {
        _damageIceAtPosition(
          specialCreation.position,
        );

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
        _clearMatchedGems(matchedPositions);
      }

      _board.applyGravity();

      _refillEmptyCells();

      specialPosition = null;
    }

    return _ResolutionResult(
      matchedPositions: allMatchedPositions,
      cascadeCount: cascadeCount,
      scoreGained: scoreGained,
    );
  }

  void _clearMatchedGems(
    Set<BoardPosition> positions,
  ) {
    final gemTypes = <GemType, int>{};

    int iceBroken = 0;

    for (final position in positions) {
      if (!_board.isInside(position)) {
        continue;
      }

      final cell = _board.cellAt(position);

      if (!cell.isAvailable || !cell.hasGem) {
        continue;
      }

      final gem = _board.gemAt(position);

      if (gem != null) {
        gemTypes[gem.type] =
            (gemTypes[gem.type] ?? 0) + 1;
      }

      if (cell.hasIce) {
        iceBroken++;
      }
    }

    _board.clearGems(positions);

    for (final entry in gemTypes.entries) {
      _goalTracker?.collectGems(
        gemType: entry.key,
        amount: entry.value,
      );
    }

    if (iceBroken > 0) {
      _goalTracker?.breakIce(iceBroken);
    }
  }

  _SpecialCreation? _selectSpecialCreation(
    MatchResult matchResult,
    BoardPosition? preferredPosition,
  ) {
    final specialType = matchResult.specialMatchType;

    if (specialType == SpecialMatchType.none) {
      return null;
    }

    BoardPosition? position;

    if (preferredPosition != null &&
        matchResult.positions.contains(preferredPosition)) {
      position = preferredPosition;
    } else {
      position = matchResult.specialGemPosition;
    }

    if (position == null) {
      return null;
    }

    final gemSpecialType = _toGemSpecialType(
      specialType,
    );

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

  Set<BoardPosition> _activateSpecial({
    required BoardPosition position,
    required Gem specialGem,
    required GemType targetType,
  }) {
    final positions = <BoardPosition>{};

    switch (specialGem.specialType) {
      case GemSpecialType.normal:
        positions.add(position);
        break;

      case GemSpecialType.rocketHorizontal:
        for (int column = 0;
            column < _board.columns;
            column++) {
          positions.add(
            BoardPosition(
              row: position.row,
              column: column,
            ),
          );
        }
        break;

      case GemSpecialType.rocketVertical:
        for (int row = 0;
            row < _board.rows;
            row++) {
          positions.add(
            BoardPosition(
              row: row,
              column: position.column,
            ),
          );
        }
        break;

      case GemSpecialType.bomb:
        positions.addAll(
          _areaPositions(
            center: position,
            radius: 1,
          ),
        );
        break;

      case GemSpecialType.colorBomb:
        for (int row = 0;
            row < _board.rows;
            row++) {
          for (int column = 0;
              column < _board.columns;
              column++) {
            final currentPosition = BoardPosition(
              row: row,
              column: column,
            );

            final gem = _board.gemAt(
              currentPosition,
            );

            if (gem?.type == targetType) {
              positions.add(currentPosition);
            }
          }
        }

        positions.add(position);
        break;
    }

    return positions;
  }

  Set<BoardPosition> _activateColorBombWithSpecial({
    required Gem colorBomb,
    required Gem special,
  }) {
    final positions = <BoardPosition>{};

    final targetType = special.type;

    for (int row = 0;
        row < _board.rows;
        row++) {
      for (int column = 0;
          column < _board.columns;
          column++) {
        final position = BoardPosition(
          row: row,
          column: column,
        );

        final gem = _board.gemAt(position);

        if (gem?.type == targetType) {
          positions.add(position);

          if (gem != null && _isRocket(gem)) {
            positions.addAll(
              _rocketPositions(
                position,
                gem.specialType,
              ),
            );
          } else if (gem?.specialType ==
              GemSpecialType.bomb) {
            positions.addAll(
              _areaPositions(
                center: position,
                radius: 1,
              ),
            );
          }
        }
      }
    }

    return positions;
  }

  Set<BoardPosition> _rocketPlusRocketPositions(
    BoardPosition first,
    BoardPosition second,
  ) {
    final positions = <BoardPosition>{};

    for (int column = 0;
        column < _board.columns;
        column++) {
      positions.add(
        BoardPosition(
          row: first.row,
          column: column,
        ),
      );

      positions.add(
        BoardPosition(
          row: second.row,
          column: column,
        ),
      );
    }

    for (int row = 0;
        row < _board.rows;
        row++) {
      positions.add(
        BoardPosition(
          row: row,
          column: first.column,
        ),
      );

      positions.add(
        BoardPosition(
          row: row,
          column: second.column,
        ),
      );
    }

    return positions;
  }

  Set<BoardPosition> _rocketPlusBombPositions(
    BoardPosition rocketPosition,
  ) {
    final positions = <BoardPosition>{};

    for (int offset = -1;
        offset <= 1;
        offset++) {
      final row = rocketPosition.row + offset;

      final column = rocketPosition.column + offset;

      if (row >= 0 && row < _board.rows) {
        for (int currentColumn = 0;
            currentColumn < _board.columns;
            currentColumn++) {
          positions.add(
            BoardPosition(
              row: row,
              column: currentColumn,
            ),
          );
        }
      }

      if (column >= 0 && column < _board.columns) {
        for (int currentRow = 0;
            currentRow < _board.rows;
            currentRow++) {
          positions.add(
            BoardPosition(
              row: currentRow,
              column: column,
            ),
          );
        }
      }
    }

    positions.addAll(
      _areaPositions(
        center: rocketPosition,
        radius: 1,
      ),
    );

    return positions;
  }

  Set<BoardPosition> _bombPlusBombPositions(
    BoardPosition first,
    BoardPosition second,
  ) {
    final positions = <BoardPosition>{};

    positions.addAll(
      _areaPositions(
        center: first,
        radius: 2,
      ),
    );

    positions.addAll(
      _areaPositions(
        center: second,
        radius: 2,
      ),
    );

    return positions;
  }

  Set<BoardPosition> _rocketPositions(
    BoardPosition position,
    GemSpecialType type,
  ) {
    final positions = <BoardPosition>{};

    if (type == GemSpecialType.rocketHorizontal) {
      for (int column = 0;
          column < _board.columns;
          column++) {
        positions.add(
          BoardPosition(
            row: position.row,
            column: column,
          ),
        );
      }
    }

    if (type == GemSpecialType.rocketVertical) {
      for (int row = 0;
          row < _board.rows;
          row++) {
        positions.add(
          BoardPosition(
            row: row,
            column: position.column,
          ),
        );
      }
    }

    return positions;
  }

  Set<BoardPosition> _areaPositions({
    required BoardPosition center,
    required int radius,
  }) {
    final positions = <BoardPosition>{};

    for (int rowOffset = -radius;
        rowOffset <= radius;
        rowOffset++) {
      for (int columnOffset = -radius;
          columnOffset <= radius;
          columnOffset++) {
        final row = center.row + rowOffset;

        final column = center.column + columnOffset;

        if (row < 0 ||
            row >= _board.rows ||
            column < 0 ||
            column >= _board.columns) {
          continue;
        }

        positions.add(
          BoardPosition(
            row: row,
            column: column,
          ),
        );
      }
    }

    return positions;
  }

  Set<BoardPosition> _allAvailableGemPositions() {
    final positions = <BoardPosition>{};

    for (int row = 0;
        row < _board.rows;
        row++) {
      for (int column = 0;
          column < _board.columns;
          column++) {
        final position = BoardPosition(
          row: row,
          column: column,
        );

        if (_board.cellAt(position).isAvailable &&
            _board.gemAt(position) != null) {
          positions.add(position);
        }
      }
    }

    return positions;
  }

  int _clearPositions(
    Set<BoardPosition> positions,
  ) {
    final gemTypes = <GemType, int>{};

    int iceBroken = 0;
    int cleared = 0;

    for (final position in positions) {
      if (!_board.isInside(position)) {
        continue;
      }

      final cell = _board.cellAt(position);

      if (!cell.isAvailable || !cell.hasGem) {
        continue;
      }

      final gem = _board.gemAt(position);

      if (gem != null) {
        gemTypes[gem.type] =
            (gemTypes[gem.type] ?? 0) + 1;
      }

      if (cell.hasIce) {
        iceBroken++;
      }

      _board.removeGem(position);

      cleared++;
    }

    for (final entry in gemTypes.entries) {
      _goalTracker?.collectGems(
        gemType: entry.key,
        amount: entry.value,
      );
    }

    if (iceBroken > 0) {
      _goalTracker?.breakIce(iceBroken);
    }

    final gained = cleared * 10;

    _score += gained;
    _goalTracker?.addScore(gained);

    return gained;
  }

  void _damageIceAtPosition(
    BoardPosition position,
  ) {
    if (!_board.isInside(position)) {
      return;
    }

    if (_board.hasIceAt(position)) {
      _board.damageIce(position);

      _goalTracker?.breakIce(1);
    }
  }

  _ResolutionResult _finishSpecialResolution({
    required Set<BoardPosition> matchedPositions,
    required int scoreGained,
  }) {
    _board.applyGravity();

    _refillEmptyCells();

    final cascade = _resolveMatches();

    matchedPositions.addAll(
      cascade.matchedPositions,
    );

    return _ResolutionResult(
      matchedPositions: matchedPositions,
      cascadeCount: 1 + cascade.cascadeCount,
      scoreGained:
          scoreGained + cascade.scoreGained,
    );
  }

  bool _isRocket(Gem gem) {
    return gem.specialType ==
            GemSpecialType.rocketHorizontal ||
        gem.specialType ==
            GemSpecialType.rocketVertical;
  }

  void _createSpecialGem({
    required BoardPosition position,
    required GemSpecialType type,
  }) {
    final existingGem = _board.gemAt(position);

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

    if (!cell.isAvailable || !cell.hasGem) {
      return;
    }

    final gem = _board.gemAt(position);

    if (gem != null) {
      _goalTracker?.collectGems(
        gemType: gem.type,
        amount: 1,
      );
    }

    if (cell.hasIce) {
      _goalTracker?.breakIce(1);
    }

    _board.removeGem(position);
  }

  void _refillEmptyCells() {
    final emptyPositions = _board.emptyPositions();

    for (final position in emptyPositions) {
      final type = _chooseRefillType(position);

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
