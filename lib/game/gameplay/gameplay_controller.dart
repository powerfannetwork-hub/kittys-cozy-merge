import 'package:flutter/foundation.dart';

import '../effects/game_effect_runtime.dart';
import 'gem_swap.dart';
import 'level_session.dart';
import 'move_result.dart';
import 'swap_result.dart';

class GameplayController extends ChangeNotifier {
  GameplayController({
    required LevelSession session,
    required double cellSize,
    Duration effectStepInterval =
        const Duration(milliseconds: 120),
  })  : _session = session,
        _runtime = GameplayEffectRuntime(
          rows: session.rows,
          columns: session.columns,
          cellSize: cellSize,
          effectStepInterval: effectStepInterval,
        );

  LevelSession _session;
  final GameplayEffectRuntime _runtime;

  bool _processingMove = false;
  bool _disposed = false;

  LevelSession get session => _session;

  GameplayEffectRuntime get runtime => _runtime;

  bool get isProcessingMove => _processingMove;

  bool get isComplete => _session.isComplete;

  bool get hasMovesRemaining =>
      _session.hasMovesRemaining;

  int get movesRemaining =>
      _session.movesRemaining;

  int get score => _session.score;

  int get levelNumber =>
      _session.levelNumber;

  int get rows => _session.rows;

  int get columns => _session.columns;

  double get goalProgress =>
      _session.goalProgress;

  bool get effectsRunning =>
      _runtime.isRunning;

  bool get effectsPaused =>
      _runtime.isPaused;

  bool get effectsComplete =>
      _runtime.isComplete;

  bool get effectsIdle =>
      _runtime.isIdle;

  MoveResult? makeMove(
    GemSwap swap,
  ) {
    _ensureActive();

    if (_processingMove) {
      return null;
    }

    if (_session.isComplete ||
        !_session.hasMovesRemaining) {
      return null;
    }

    _processingMove = true;
    notifyListeners();

    try {
      final swapResult =
          _session.engine.trySwap(swap);

      _runtime.coordinator.dispatchSwap(
        swapResult,
      );

      if (!swapResult.isSuccessful) {
        return null;
      }

      final result = MoveResult(
        from: swapResult.from,
        to: swapResult.to,
        movesRemaining:
            _session.movesRemaining,
        matchedGemCount:
            swapResult.matchedPositions.length,
        cascadeCount:
            swapResult.cascadeCount,
        scoreGained:
            swapResult.scoreGained,
      );

      return result;
    } finally {
      _processingMove = false;
      notifyListeners();
    }
  }

  SwapResult evaluateSwap(
    GemSwap swap,
  ) {
    _ensureActive();

    return _session.engine.trySwap(swap);
  }

  void restart() {
    _ensureActive();

    _runtime.stop();

    _session = LevelSession.create(
      levelNumber: levelNumber,
    );

    _processingMove = false;

    notifyListeners();
  }

  void stopEffects() {
    _ensureActive();

    _runtime.stop();
    notifyListeners();
  }

  void pauseEffects() {
    _ensureActive();

    _runtime.coordinator.pause();
    notifyListeners();
  }

  void resumeEffects() {
    _ensureActive();

    _runtime.coordinator.resume();
    notifyListeners();
  }

  @override
  void dispose() {
    if (_disposed) {
      return;
    }

    _disposed = true;

    _runtime.dispose();

    super.dispose();
  }

  void _ensureActive() {
    if (_disposed) {
      throw StateError(
        'GameplayController has already been disposed.',
      );
    }
  }
}
