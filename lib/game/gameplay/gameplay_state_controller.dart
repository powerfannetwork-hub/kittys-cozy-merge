import 'package:flutter/foundation.dart';

import 'gameplay_controller.dart';
import 'gameplay_state.dart';

class GameplayStateController extends ChangeNotifier {
  GameplayStateController({
    required GameplayController gameplay,
  }) : _gameplay = gameplay {
    _gameplay.addListener(_handleGameplayChanged);
    _status = _buildStatus();
  }

  final GameplayController _gameplay;

  late GameplayStatus _status;

  bool _disposed = false;

  GameplayController get gameplay => _gameplay;

  GameplayStatus get status => _status;

  GameplayState get state => _status.state;

  int get movesRemaining =>
      _status.movesRemaining;

  int get score =>
      _status.score;

  double get goalProgress =>
      _status.goalProgress;

  bool get isReady =>
      _status.isReady;

  bool get isPlaying =>
      _status.isPlaying;

  bool get isComplete =>
      _status.isComplete;

  bool get isOutOfMoves =>
      _status.isOutOfMoves;

  bool get canMakeMove =>
      _status.canMakeMove &&
      !_gameplay.isProcessingMove;

  void refresh() {
    _ensureActive();

    _updateStatus();
  }

  void markPlaying() {
    _ensureActive();

    if (_status.isComplete ||
        _status.isOutOfMoves) {
      return;
    }

    _setStatus(
      _status.copyWith(
        state: GameplayState.playing,
      ),
    );
  }

  void markReady() {
    _ensureActive();

    if (_status.isComplete ||
        _status.isOutOfMoves) {
      return;
    }

    _setStatus(
      _status.copyWith(
        state: GameplayState.ready,
      ),
    );
  }

  void restart() {
    _ensureActive();

    _gameplay.restart();

    _updateStatus(
      notify: false,
    );

    notifyListeners();
  }

  void _handleGameplayChanged() {
    if (_disposed) {
      return;
    }

    _updateStatus();
  }

  void _updateStatus({
    bool notify = true,
  }) {
    final nextStatus = _buildStatus();

    if (nextStatus == _status) {
      return;
    }

    _status = nextStatus;

    if (notify) {
      notifyListeners();
    }
  }

  GameplayStatus _buildStatus() {
    final isComplete =
        _gameplay.isComplete;

    final hasMoves =
        _gameplay.hasMovesRemaining;

    final isProcessing =
        _gameplay.isProcessingMove;

    GameplayState nextState;

    if (isComplete) {
      nextState =
          GameplayState.levelComplete;
    } else if (!hasMoves) {
      nextState =
          GameplayState.outOfMoves;
    } else if (isProcessing) {
      nextState =
          GameplayState.playing;
    } else {
      final currentState =
          _status.state;

      if (currentState ==
          GameplayState.playing) {
        nextState =
            GameplayState.playing;
      } else {
        nextState =
            GameplayState.ready;
      }
    }

    return GameplayStatus(
      state: nextState,
      movesRemaining:
          _gameplay.movesRemaining,
      score:
          _gameplay.score,
      goalProgress:
          _gameplay.goalProgress,
    );
  }

  void _setStatus(
    GameplayStatus nextStatus,
  ) {
    if (_status == nextStatus) {
      return;
    }

    _status = nextStatus;

    notifyListeners();
  }

  void _ensureActive() {
    if (_disposed) {
      throw StateError(
        'GameplayStateController has already been disposed.',
      );
    }
  }

  @override
  void dispose() {
    if (_disposed) {
      return;
    }

    _disposed = true;

    _gameplay.removeListener(
      _handleGameplayChanged,
    );

    super.dispose();
  }
}
