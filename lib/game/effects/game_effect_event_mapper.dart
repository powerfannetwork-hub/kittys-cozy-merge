import 'package:flutter/material.dart';

import '../board/board_position.dart';
import 'effect_position_mapper.dart';
import 'effect_sequence.dart';
import 'effect_sequence_factory.dart';
import 'game_animation_controller.dart';
import 'game_effect_event.dart';

class GameEffectEventMapper {
  GameEffectEventMapper({
    required this.positionMapper,
  });

  final EffectPositionMapper positionMapper;

  EffectSequence map(
    GameEffectEvent event,
  ) {
    switch (event.type) {
      case GameEffectEventType.swap:
        return _mapSwap(event);

      case GameEffectEventType.swapBack:
        return _mapSwapBack(event);

      case GameEffectEventType.match:
        return _mapMatch(event);

      case GameEffectEventType.gemRemoved:
        return _mapGemRemoved(event);

      case GameEffectEventType.gemCollected:
        return _mapGemCollected(event);

      case GameEffectEventType.gemFall:
        return _mapGemFall(event);

      case GameEffectEventType.specialGemCreated:
        return _mapSpecialGemCreated(event);

      case GameEffectEventType.specialGemActivated:
        return _mapSpecialGemActivated(event);

      case GameEffectEventType.cascade:
        return _mapCascade(event);

      case GameEffectEventType.goalComplete:
        return _mapGoalComplete(event);

      case GameEffectEventType.invalidMove:
        return _mapInvalidMove(event);
    }
  }

  EffectSequence _mapSwap(
    GameEffectEvent event,
  ) {
    if (!event.hasSwap) {
      return _emptySequence();
    }

    return EffectSequenceFactory.swap(
      from: _center(event.from!),
      to: _center(event.to!),
    );
  }

  EffectSequence _mapSwapBack(
    GameEffectEvent event,
  ) {
    if (!event.hasSwap) {
      return _emptySequence();
    }

    return EffectSequenceFactory.swapBack(
      from: _center(event.from!),
      to: _center(event.to!),
    );
  }

  EffectSequence _mapMatch(
    GameEffectEvent event,
  ) {
    final positions = _centers(event.positions);

    if (positions.isEmpty && event.hasPosition) {
      positions.add(
        _center(event.position!),
      );
    }

    if (positions.isEmpty) {
      return _emptySequence();
    }

    return EffectSequenceFactory.match(
      positions: positions,
      color: event.color,
    );
  }

  EffectSequence _mapGemRemoved(
    GameEffectEvent event,
  ) {
    final positions = _eventPositions(event);

    if (positions.isEmpty) {
      return _emptySequence();
    }

    return EffectSequenceFactory.sparkle(
      positions: positions,
      color: event.color,
    );
  }

  EffectSequence _mapGemCollected(
    GameEffectEvent event,
  ) {
    final positions = _eventPositions(event);

    if (positions.isEmpty) {
      return _emptySequence();
    }

    return EffectSequenceFactory.sparkle(
      positions: positions,
      color: event.color,
    );
  }

  EffectSequence _mapGemFall(
    GameEffectEvent event,
  ) {
    final positions = _eventPositions(event);

    if (positions.isEmpty) {
      return _emptySequence();
    }

    return EffectSequence(
      steps: [
        EffectSequenceStep(
          type: event.animationType ??
              GameAnimationType.gemFall,
          duration: const Duration(
            milliseconds: 260,
          ),
          positions: positions,
          color: event.color,
        ),
      ],
    );
  }

  EffectSequence _mapSpecialGemCreated(
    GameEffectEvent event,
  ) {
    final position = event.position;

    if (position == null) {
      return _emptySequence();
    }

    final animationType =
        event.animationType ??
            GameAnimationType.specialGem;

    return EffectSequence(
      steps: [
        EffectSequenceStep(
          type: animationType,
          duration: const Duration(
            milliseconds: 260,
          ),
          position: _center(position),
          color: event.color,
        ),
      ],
    );
  }

  EffectSequence _mapSpecialGemActivated(
    GameEffectEvent event,
  ) {
    final position = event.position;

    if (position == null) {
      return _emptySequence();
    }

    final animationType =
        event.animationType ??
            GameAnimationType.specialGem;

    return EffectSequence(
      steps: [
        EffectSequenceStep(
          type: animationType,
          duration: const Duration(
            milliseconds: 300,
          ),
          position: _center(position),
          positions: _centers(event.positions),
          color: event.color,
        ),
      ],
    );
  }

  EffectSequence _mapCascade(
    GameEffectEvent event,
  ) {
    final positions = _eventPositions(event);

    if (positions.isEmpty) {
      return _emptySequence();
    }

    return EffectSequence(
      steps: [
        EffectSequenceStep(
          type: event.animationType ??
              GameAnimationType.gemMatch,
          duration: const Duration(
            milliseconds: 220,
          ),
          positions: positions,
          color: event.color,
          intensity: event.chain > 0
              ? 1.0 + (event.chain * 0.1)
              : 1.0,
        ),
      ],
    );
  }

  EffectSequence _mapGoalComplete(
    GameEffectEvent event,
  ) {
    final position = event.position;

    if (position == null) {
      return _emptySequence();
    }

    return EffectSequenceFactory.goalComplete(
      position: _center(position),
      color: event.color,
    );
  }

  EffectSequence _mapInvalidMove(
    GameEffectEvent event,
  ) {
    final position =
        event.position ??
        event.from;

    if (position == null) {
      return _emptySequence();
    }

    return EffectSequenceFactory.invalidMove(
      position: _center(position),
      color: event.color,
    );
  }

  List<Offset> _eventPositions(
    GameEffectEvent event,
  ) {
    if (event.positions.isNotEmpty) {
      return _centers(event.positions);
    }

    if (event.position != null) {
      return [
        _center(event.position!),
      ];
    }

    return <Offset>[];
  }

  List<Offset> _centers(
    Iterable<BoardPosition> positions,
  ) {
    return positionMapper.centers(
      positions,
    );
  }

  Offset _center(
    BoardPosition position,
  ) {
    return positionMapper.center(
      position,
    );
  }

  EffectSequence _emptySequence() {
    return EffectSequence();
  }
}
