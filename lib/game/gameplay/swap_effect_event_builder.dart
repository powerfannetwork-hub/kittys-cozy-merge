import '../board/board_position.dart';
import '../effects/game_effect_event_batch.dart';
import '../effects/game_effect_event_factory.dart';
import 'swap_result.dart';

class SwapEffectEventBuilder {
  const SwapEffectEventBuilder();

  GameEffectEventBatch build(
    SwapResult result,
  ) {
    if (result.status == SwapStatus.invalid) {
      return GameEffectEventBatch(
        events: [
          GameEffectEventFactory.invalidMove(
            position: result.from,
            to: result.to,
          ),
        ],
      );
    }

    if (result.status == SwapStatus.noMatch) {
      return GameEffectEventBatch(
        events: [
          GameEffectEventFactory.swapBack(
            from: result.from,
            to: result.to,
          ),
          GameEffectEventFactory.invalidMove(
            position: result.from,
            to: result.to,
          ),
        ],
      );
    }

    final events = <dynamic>[];

    events.add(
      GameEffectEventFactory.swap(
        from: result.from,
        to: result.to,
      ),
    );

    if (result.matchedPositions.isNotEmpty) {
      events.add(
        GameEffectEventFactory.match(
          positions: result.matchedPositions,
          count: result.matchedPositions.length,
          score: result.scoreGained,
        ),
      );
    }

    if (result.cascadeCount > 1 &&
        result.matchedPositions.isNotEmpty) {
      events.add(
        GameEffectEventFactory.cascade(
          positions: result.matchedPositions,
          chain: result.cascadeCount,
          score: result.scoreGained,
        ),
      );
    }

    return GameEffectEventBatch(
      events: List.unmodifiable(events),
    );
  }

  GameEffectEventBatch buildSuccessful(
    SwapResult result,
  ) {
    if (!result.isSuccessful) {
      return build(result);
    }

    return build(result);
  }

  GameEffectEventBatch buildRejected(
    SwapResult result,
  ) {
    if (result.status == SwapStatus.invalid) {
      return GameEffectEventBatch(
        events: [
          GameEffectEventFactory.invalidMove(
            position: result.from,
            to: result.to,
          ),
        ],
      );
    }

    return GameEffectEventBatch(
      events: [
        GameEffectEventFactory.swapBack(
          from: result.from,
          to: result.to,
        ),
        GameEffectEventFactory.invalidMove(
          position: result.from,
          to: result.to,
        ),
      ],
    );
  }

  GameEffectEventBatch buildMatchOnly(
    SwapResult result,
  ) {
    if (!result.isSuccessful ||
        result.matchedPositions.isEmpty) {
      return const GameEffectEventBatch();
    }

    return GameEffectEventBatch(
      events: [
        GameEffectEventFactory.match(
          positions: result.matchedPositions,
          count: result.matchedPositions.length,
          score: result.scoreGained,
        ),
      ],
    );
  }

  GameEffectEventBatch buildCascadeOnly(
    SwapResult result,
  ) {
    if (!result.isSuccessful ||
        result.cascadeCount <= 1 ||
        result.matchedPositions.isEmpty) {
      return const GameEffectEventBatch();
    }

    return GameEffectEventBatch(
      events: [
        GameEffectEventFactory.cascade(
          positions: result.matchedPositions,
          chain: result.cascadeCount,
          score: result.scoreGained,
        ),
      ],
    );
  }

  GameEffectEventBatch buildCustom({
    required SwapResult result,
    Iterable<BoardPosition> removedPositions =
        const <BoardPosition>[],
    Iterable<BoardPosition> fallingPositions =
        const <BoardPosition>[],
  }) {
    if (result.status == SwapStatus.invalid) {
      return buildRejected(result);
    }

    if (result.status == SwapStatus.noMatch) {
      return buildRejected(result);
    }

    final events = <dynamic>[
      GameEffectEventFactory.swap(
        from: result.from,
        to: result.to,
      ),
    ];

    if (result.matchedPositions.isNotEmpty) {
      events.add(
        GameEffectEventFactory.match(
          positions: result.matchedPositions,
          count: result.matchedPositions.length,
          score: result.scoreGained,
        ),
      );
    }

    final removed = List<BoardPosition>.from(
      removedPositions,
    );

    if (removed.isNotEmpty) {
      events.add(
        GameEffectEventFactory.gemsRemoved(
          positions: removed,
        ),
      );
    }

    final falling = List<BoardPosition>.from(
      fallingPositions,
    );

    if (falling.isNotEmpty) {
      events.add(
        GameEffectEventFactory.gemFall(
          positions: falling,
        ),
      );
    }

    if (result.cascadeCount > 1 &&
        result.matchedPositions.isNotEmpty) {
      events.add(
        GameEffectEventFactory.cascade(
          positions: result.matchedPositions,
          chain: result.cascadeCount,
          score: result.scoreGained,
        ),
      );
    }

    return GameEffectEventBatch(
      events: List.unmodifiable(events),
    );
  }
}
