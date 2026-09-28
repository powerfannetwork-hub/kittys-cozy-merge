import 'package:flutter/foundation.dart';

enum GameplayState {
  ready,
  playing,
  levelComplete,
  outOfMoves,
}

@immutable
class GameplayStatus {
  const GameplayStatus({
    required this.state,
    required this.movesRemaining,
    required this.score,
    required this.goalProgress,
  });

  const GameplayStatus.ready({
    required int movesRemaining,
    required int score,
    required double goalProgress,
  }) : this(
          state: GameplayState.ready,
          movesRemaining: movesRemaining,
          score: score,
          goalProgress: goalProgress,
        );

  final GameplayState state;
  final int movesRemaining;
  final int score;
  final double goalProgress;

  bool get isReady =>
      state == GameplayState.ready;

  bool get isPlaying =>
      state == GameplayState.playing;

  bool get isComplete =>
      state == GameplayState.levelComplete;

  bool get isOutOfMoves =>
      state == GameplayState.outOfMoves;

  bool get canMakeMove =>
      state == GameplayState.ready ||
      state == GameplayState.playing;

  GameplayStatus copyWith({
    GameplayState? state,
    int? movesRemaining,
    int? score,
    double? goalProgress,
  }) {
    return GameplayStatus(
      state: state ?? this.state,
      movesRemaining:
          movesRemaining ?? this.movesRemaining,
      score: score ?? this.score,
      goalProgress:
          goalProgress ?? this.goalProgress,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GameplayStatus &&
        other.state == state &&
        other.movesRemaining ==
            movesRemaining &&
        other.score == score &&
        other.goalProgress ==
            goalProgress;
  }

  @override
  int get hashCode {
    return Object.hash(
      state,
      movesRemaining,
      score,
      goalProgress,
    );
  }

  @override
  String toString() {
    return 'GameplayStatus('
        'state: $state, '
        'movesRemaining: $movesRemaining, '
        'score: $score, '
        'goalProgress: $goalProgress'
        ')';
  }
}
