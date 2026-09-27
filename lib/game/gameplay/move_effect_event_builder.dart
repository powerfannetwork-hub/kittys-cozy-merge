import '../board/board_position.dart';
import '../effects/game_effect_event.dart';
import '../effects/game_effect_event_batch.dart';
import '../effects/game_effect_event_factory.dart';
import 'move_result.dart';

class MoveEffectEventBuilder {
  const MoveEffectEventBuilder();

  GameEffectEventBatch build({
    required MoveResult result,
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
    final builder = GameEffectEventBatchBuilder();

    builder.add(
      GameEffectEventFactory.swap(
        from: result.from,
        to: result.to,
      ),
    );

    final matches = List<BoardPosition>.from(
      matchedPositions,
    );

    if (matches.isNotEmpty) {
      builder.add(
        GameEffectEventFactory.match(
          positions: matches,
          count: result.matchedGemCount,
          score: result.scoreGained,
        ),
      );
    }

    final removed = List<BoardPosition>.from(
      removedPositions,
    );

    if (removed.isNotEmpty) {
      builder.add(
        GameEffectEventFactory.gemsRemoved(
          positions: removed,
        ),
      );
    }

    final falling = List<BoardPosition>.from(
      fallingPositions,
    );

    if (falling.isNotEmpty) {
      builder.add(
        GameEffectEventFactory.gemFall(
          positions: falling,
        ),
      );
    }

    if (specialGemEvent != null) {
      builder.add(
        specialGemEvent,
      );
    } else if (specialGemPosition != null) {
      builder.add(
        GameEffectEventFactory.specialGemCreated(
          position: specialGemPosition,
        ),
      );
    }

    if (result.cascadeCount > 1 &&
        matches.isNotEmpty) {
      builder.add(
        GameEffectEventFactory.cascade(
          positions: matches,
          chain: result.cascadeCount,
          score: result.scoreGained,
        ),
      );
    }

    if (goalCompletePosition != null) {
      builder.add(
        GameEffectEventFactory.goalComplete(
          position: goalCompletePosition,
        ),
      );
    }

    return builder.build();
  }

  GameEffectEventBatch buildSwapOnly({
    required MoveResult result,
  }) {
    return GameEffectEventBatch(
      events: [
        GameEffectEventFactory.swap(
          from: result.from,
          to: result.to,
        ),
      ],
    );
  }

  GameEffectEventBatch buildMatch({
    required MoveResult result,
    required Iterable<BoardPosition> positions,
  }) {
    return GameEffectEventBatch(
      events: [
        GameEffectEventFactory.swap(
          from: result.from,
          to: result.to,
        ),
        GameEffectEventFactory.match(
          positions: positions,
          count: result.matchedGemCount,
          score: result.scoreGained,
        ),
      ],
    );
  }

  GameEffectEventBatch buildCascade({
    required MoveResult result,
    required Iterable<BoardPosition> positions,
  }) {
    return GameEffectEventBatch(
      events: [
        GameEffectEventFactory.swap(
          from: result.from,
          to: result.to,
        ),
        GameEffectEventFactory.match(
          positions: positions,
          count: result.matchedGemCount,
          score: result.scoreGained,
        ),
        if (result.cascadeCount > 1)
          GameEffectEventFactory.cascade(
            positions: positions,
            chain: result.cascadeCount,
            score: result.scoreGained,
          ),
      ],
    );
  }

  GameEffectEventBatch buildInvalidMove({
    required BoardPosition from,
    required BoardPosition to,
  }) {
    return GameEffectEventBatch(
      events: [
        GameEffectEventFactory.invalidMove(
          position: from,
          to: to,
        ),
      ],
    );
  }
}
