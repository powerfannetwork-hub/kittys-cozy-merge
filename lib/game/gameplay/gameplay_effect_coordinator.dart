import '../board/board_position.dart';
import '../effects/game_effect_dispatcher.dart';
import '../effects/game_effect_event.dart';
import '../effects/game_effect_event_batch.dart';
import 'move_effect_event_builder.dart';
import 'move_result.dart';
import 'swap_effect_event_builder.dart';
import 'swap_result.dart';

class GameplayEffectCoordinator {
  GameplayEffectCoordinator({
    required GameEffectDispatcher dispatcher,
    MoveEffectEventBuilder? moveBuilder,
    SwapEffectEventBuilder? swapBuilder,
  })  : _dispatcher = dispatcher,
        _moveBuilder =
            moveBuilder ?? const MoveEffectEventBuilder(),
        _swapBuilder =
            swapBuilder ?? const SwapEffectEventBuilder();

  final GameEffectDispatcher _dispatcher;
  final MoveEffectEventBuilder _moveBuilder;
  final SwapEffectEventBuilder _swapBuilder;

  GameEffectDispatcher get dispatcher => _dispatcher;

  MoveEffectEventBuilder get moveBuilder => _moveBuilder;

  SwapEffectEventBuilder get swapBuilder => _swapBuilder;

  bool get isRunning => _dispatcher.isRunning;

  bool get isPaused => _dispatcher.isPaused;

  bool get isComplete => _dispatcher.isComplete;

  bool get isIdle => _dispatcher.isIdle;

  void dispatchMove(
    MoveResult result, {
    Iterable<BoardPosition> matchedPositions =
        const <BoardPosition>[],
    Iterable<BoardPosition> removedPositions =
        const <BoardPosition>[],
    Iterable<BoardPosition> fallingPositions =
        const <BoardPosition>[],
    BoardPosition? specialGemPosition,
    GameEffectEvent? specialGemEvent,
    BoardPosition? goalCompletePosition,
  }) {
    final batch = _moveBuilder.build(
      result: result,
      matchedPositions: matchedPositions,
      removedPositions: removedPositions,
      fallingPositions: fallingPositions,
      specialGemPosition: specialGemPosition,
      specialGemEvent: specialGemEvent,
      goalCompletePosition: goalCompletePosition,
    );

    _dispatchBatch(batch);
  }

  void dispatchMoveBatch(
    GameEffectEventBatch batch,
  ) {
    _dispatchBatch(batch);
  }

  void dispatchSwap(
    SwapResult result,
  ) {
    final batch = _swapBuilder.build(result);

    _dispatchBatch(batch);
  }

  void dispatchSuccessfulSwap(
    SwapResult result,
  ) {
    final batch = _swapBuilder.buildSuccessful(result);

    _dispatchBatch(batch);
  }

  void dispatchRejectedSwap(
    SwapResult result,
  ) {
    final batch = _swapBuilder.buildRejected(result);

    _dispatchBatch(batch);
  }

  void dispatchMatchOnly(
    SwapResult result,
  ) {
    final batch = _swapBuilder.buildMatchOnly(result);

    _dispatchBatch(batch);
  }

  void dispatchCascadeOnly(
    SwapResult result,
  ) {
    final batch = _swapBuilder.buildCascadeOnly(result);

    _dispatchBatch(batch);
  }

  void dispatchInvalidMove({
    required BoardPosition from,
    required BoardPosition to,
  }) {
    final batch = _moveBuilder.buildInvalidMove(
      from: from,
      to: to,
    );

    _dispatchBatch(batch);
  }

  void dispatchEvent(
    GameEffectEvent event,
  ) {
    _dispatcher.dispatch(event);
  }

  void dispatchBatch(
    GameEffectEventBatch batch,
  ) {
    _dispatchBatch(batch);
  }

  void pause() {
    _dispatcher.pause();
  }

  void resume() {
    _dispatcher.resume();
  }

  void next() {
    _dispatcher.next();
  }

  void skipCurrent() {
    _dispatcher.skipCurrent();
  }

  void completeCurrent() {
    _dispatcher.completeCurrent();
  }

  void stop() {
    _dispatcher.stop();
  }

  void reset() {
    _dispatcher.reset();
  }

  void clear() {
    _dispatcher.clear();
  }

  void _dispatchBatch(
    GameEffectEventBatch batch,
  ) {
    if (batch.isEmpty) {
      return;
    }

    _dispatcher.dispatchBatch(batch);
  }
}
