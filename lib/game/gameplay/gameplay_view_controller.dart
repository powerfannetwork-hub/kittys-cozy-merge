import 'package:flutter/foundation.dart';

import '../board/board_position.dart';
import 'gameplay_controller.dart';
import 'gem_swap.dart';
import 'level_session.dart';
import 'move_result.dart';

class GameplayViewController extends ChangeNotifier {
  GameplayViewController({
    required LevelSession session,
    required double cellSize,
  }) : _gameplay = GameplayController(
          session: session,
          cellSize: cellSize,
        );

  final GameplayController _gameplay;

  BoardPosition? _selectedPosition;

  bool _disposed = false;

  GameplayController get gameplay => _gameplay;

  LevelSession get session => _gameplay.session;

  BoardPosition? get selectedPosition =>
      _selectedPosition;

  bool get isProcessingMove =>
      _gameplay.isProcessingMove;

  bool get isComplete =>
      _gameplay.isComplete;

  bool get hasMovesRemaining =>
      _gameplay.hasMovesRemaining;

  int get movesRemaining =>
      _gameplay.movesRemaining;

  int get score =>
      _gameplay.score;

  int get levelNumber =>
      _gameplay.levelNumber;

  int get rows =>
      _gameplay.rows;

  int get columns =>
      _gameplay.columns;

  double get goalProgress =>
      _gameplay.goalProgress;

  bool get effectsRunning =>
      _gameplay.effectsRunning;

  bool get effectsPaused =>
      _gameplay.effectsPaused;

  bool get effectsComplete =>
      _gameplay.effectsComplete;

  bool get effectsIdle =>
      _gameplay.effectsIdle;

  bool canSelect(
    BoardPosition position,
  ) {
    _ensureActive();

    if (_gameplay.isProcessingMove ||
        !_gameplay.hasMovesRemaining ||
        _gameplay.isComplete) {
      return false;
    }

    if (!_gameplay.session.board.isInside(
      position,
    )) {
      return false;
    }

    final cell =
        _gameplay.session.board.cellAt(
      position,
    );

    return cell.isAvailable &&
        cell.hasGem;
  }

  void select(
    BoardPosition position,
  ) {
    _ensureActive();

    if (!canSelect(position)) {
      return;
    }

    if (_selectedPosition == position) {
      return;
    }

    _selectedPosition = position;

    notifyListeners();
  }

  void clearSelection() {
    _ensureActive();

    if (_selectedPosition == null) {
      return;
    }

    _selectedPosition = null;

    notifyListeners();
  }

  void updateSelection(
    BoardPosition? position,
  ) {
    _ensureActive();

    if (position == null) {
      clearSelection();
      return;
    }

    if (!canSelect(position)) {
      clearSelection();
      return;
    }

    if (_selectedPosition == position) {
      return;
    }

    _selectedPosition = position;

    notifyListeners();
  }

  MoveResult? swap(
    BoardPosition from,
    BoardPosition to,
  ) {
    _ensureActive();

    if (_gameplay.isProcessingMove) {
      return null;
    }

    if (!from.isAdjacentTo(to)) {
      clearSelection();
      return null;
    }

    final GemSwap swap = GemSwap(
      from: from,
      to: to,
    );

    final MoveResult? result =
        _gameplay.makeMove(swap);

    _selectedPosition = null;

    notifyListeners();

    return result;
  }

  MoveResult? swapSelectedWith(
    BoardPosition position,
  ) {
    _ensureActive();

    final BoardPosition? selected =
        _selectedPosition;

    if (selected == null) {
      return null;
    }

    return swap(
      selected,
      position,
    );
  }

  void restart() {
    _ensureActive();

    _gameplay.restart();

    _selectedPosition = null;

    notifyListeners();
  }

  void pauseEffects() {
    _ensureActive();

    _gameplay.pauseEffects();

    notifyListeners();
  }

  void resumeEffects() {
    _ensureActive();

    _gameplay.resumeEffects();

    notifyListeners();
  }

  void stopEffects() {
    _ensureActive();

    _gameplay.stopEffects();

    notifyListeners();
  }

  @override
  void dispose() {
    if (_disposed) {
      return;
    }

    _disposed = true;

    _gameplay.dispose();

    super.dispose();
  }

  void _ensureActive() {
    if (_disposed) {
      throw StateError(
        'GameplayViewController has already been disposed.',
      );
    }
  }
}
