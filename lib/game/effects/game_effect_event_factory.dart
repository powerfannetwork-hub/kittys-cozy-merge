import 'package:flutter/material.dart';

import '../board/board_position.dart';
import '../gems/gem.dart';
import 'game_animation_controller.dart';
import 'game_effect_event.dart';

class GameEffectEventFactory {
  GameEffectEventFactory._();

  static GameEffectEvent swap({
    required BoardPosition from,
    required BoardPosition to,
    Color color = Colors.white,
  }) {
    return GameEffectEvent(
      type: GameEffectEventType.swap,
      from: from,
      to: to,
      color: color,
      animationType: GameAnimationType.swap,
    );
  }

  static GameEffectEvent swapBack({
    required BoardPosition from,
    required BoardPosition to,
    Color color = Colors.white,
  }) {
    return GameEffectEvent(
      type: GameEffectEventType.swapBack,
      from: from,
      to: to,
      color: color,
      animationType: GameAnimationType.swapBack,
    );
  }

  static GameEffectEvent match({
    required Iterable<BoardPosition> positions,
    Color color = Colors.white,
    int count = 0,
    int score = 0,
  }) {
    final positionList = List<BoardPosition>.unmodifiable(
      positions,
    );

    return GameEffectEvent(
      type: GameEffectEventType.match,
      positions: positionList,
      color: color,
      animationType: GameAnimationType.gemMatch,
      count: count > 0 ? count : positionList.length,
      score: score,
    );
  }

  static GameEffectEvent gemRemoved({
    required BoardPosition position,
    Gem? gem,
    Color color = Colors.white,
  }) {
    return GameEffectEvent(
      type: GameEffectEventType.gemRemoved,
      position: position,
      gem: gem,
      color: color,
      animationType: GameAnimationType.gemCollect,
      count: 1,
    );
  }

  static GameEffectEvent gemsRemoved({
    required Iterable<BoardPosition> positions,
    Iterable<Gem> gems = const <Gem>[],
    Color color = Colors.white,
  }) {
    final positionList = List<BoardPosition>.unmodifiable(
      positions,
    );

    final gemList = List<Gem>.unmodifiable(
      gems,
    );

    return GameEffectEvent(
      type: GameEffectEventType.gemRemoved,
      positions: positionList,
      gems: gemList,
      color: color,
      animationType: GameAnimationType.gemCollect,
      count: positionList.length,
    );
  }

  static GameEffectEvent gemCollected({
    required BoardPosition position,
    Gem? gem,
    Color color = Colors.white,
  }) {
    return GameEffectEvent(
      type: GameEffectEventType.gemCollected,
      position: position,
      gem: gem,
      color: color,
      animationType: GameAnimationType.gemCollect,
      count: 1,
    );
  }

  static GameEffectEvent gemsCollected({
    required Iterable<BoardPosition> positions,
    Iterable<Gem> gems = const <Gem>[],
    Color color = Colors.white,
  }) {
    final positionList = List<BoardPosition>.unmodifiable(
      positions,
    );

    final gemList = List<Gem>.unmodifiable(
      gems,
    );

    return GameEffectEvent(
      type: GameEffectEventType.gemCollected,
      positions: positionList,
      gems: gemList,
      color: color,
      animationType: GameAnimationType.gemCollect,
      count: positionList.length,
    );
  }

  static GameEffectEvent gemFall({
    required Iterable<BoardPosition> positions,
    Color color = Colors.white,
  }) {
    final positionList = List<BoardPosition>.unmodifiable(
      positions,
    );

    return GameEffectEvent(
      type: GameEffectEventType.gemFall,
      positions: positionList,
      color: color,
      animationType: GameAnimationType.gemFall,
      count: positionList.length,
    );
  }

  static GameEffectEvent specialGemCreated({
    required BoardPosition position,
    Gem? gem,
    GameAnimationType animationType =
        GameAnimationType.specialGem,
    Color color = Colors.white,
  }) {
    return GameEffectEvent(
      type: GameEffectEventType.specialGemCreated,
      position: position,
      gem: gem,
      color: color,
      animationType: animationType,
      count: 1,
    );
  }

  static GameEffectEvent specialGemActivated({
    required BoardPosition position,
    Iterable<BoardPosition> affectedPositions =
        const <BoardPosition>[],
    Gem? gem,
    GameAnimationType animationType =
        GameAnimationType.specialGem,
    Color color = Colors.white,
  }) {
    final positionList =
        List<BoardPosition>.unmodifiable(
      affectedPositions,
    );

    return GameEffectEvent(
      type: GameEffectEventType.specialGemActivated,
      position: position,
      positions: positionList,
      gem: gem,
      color: color,
      animationType: animationType,
      count: positionList.length,
    );
  }

  static GameEffectEvent rocket({
    required BoardPosition position,
    Iterable<BoardPosition> affectedPositions =
        const <BoardPosition>[],
    bool horizontal = true,
    Color color = Colors.white,
  }) {
    final positionList =
        List<BoardPosition>.unmodifiable(
      affectedPositions,
    );

    return GameEffectEvent(
      type: GameEffectEventType.specialGemActivated,
      position: position,
      positions: positionList,
      color: color,
      animationType: GameAnimationType.rocket,
      count: positionList.length,
    );
  }

  static GameEffectEvent bomb({
    required BoardPosition position,
    Iterable<BoardPosition> affectedPositions =
        const <BoardPosition>[],
    Color color = Colors.white,
  }) {
    final positionList =
        List<BoardPosition>.unmodifiable(
      affectedPositions,
    );

    return GameEffectEvent(
      type: GameEffectEventType.specialGemActivated,
      position: position,
      positions: positionList,
      color: color,
      animationType: GameAnimationType.bomb,
      count: positionList.length,
    );
  }

  static GameEffectEvent colorBomb({
    required BoardPosition position,
    Iterable<BoardPosition> affectedPositions =
        const <BoardPosition>[],
    Color color = Colors.white,
  }) {
    final positionList =
        List<BoardPosition>.unmodifiable(
      affectedPositions,
    );

    return GameEffectEvent(
      type: GameEffectEventType.specialGemActivated,
      position: position,
      positions: positionList,
      color: color,
      animationType: GameAnimationType.colorBomb,
      count: positionList.length,
    );
  }

  static GameEffectEvent cascade({
    required Iterable<BoardPosition> positions,
    int chain = 1,
    int score = 0,
    Color color = Colors.white,
  }) {
    final positionList = List<BoardPosition>.unmodifiable(
      positions,
    );

    return GameEffectEvent(
      type: GameEffectEventType.cascade,
      positions: positionList,
      color: color,
      animationType: GameAnimationType.gemMatch,
      count: positionList.length,
      chain: chain > 0 ? chain : 0,
      score: score > 0 ? score : 0,
    );
  }

  static GameEffectEvent goalComplete({
    required BoardPosition position,
    Color color = Colors.white,
  }) {
    return GameEffectEvent(
      type: GameEffectEventType.goalComplete,
      position: position,
      color: color,
      animationType: GameAnimationType.goalComplete,
      count: 1,
    );
  }

  static GameEffectEvent invalidMove({
    required BoardPosition position,
    BoardPosition? to,
    Color color = Colors.white,
  }) {
    return GameEffectEvent(
      type: GameEffectEventType.invalidMove,
      from: position,
      to: to,
      position: position,
      color: color,
      animationType: GameAnimationType.invalidMove,
    );
  }

  static GameEffectEvent fromGem({
    required GameEffectEventType type,
    required BoardPosition position,
    required Gem gem,
    Color color = Colors.white,
    GameAnimationType? animationType,
    int count = 1,
    int score = 0,
  }) {
    return GameEffectEvent(
      type: type,
      position: position,
      gem: gem,
      color: color,
      animationType: animationType,
      count: count,
      score: score,
    );
  }

  static GameEffectEvent custom({
    required GameEffectEventType type,
    BoardPosition? from,
    BoardPosition? to,
    BoardPosition? position,
    Iterable<BoardPosition> positions =
        const <BoardPosition>[],
    Gem? gem,
    Iterable<Gem> gems = const <Gem>[],
    Color color = Colors.white,
    GameAnimationType? animationType,
    int score = 0,
    int count = 0,
    int chain = 0,
  }) {
    return GameEffectEvent(
      type: type,
      from: from,
      to: to,
      position: position,
      positions:
          List<BoardPosition>.unmodifiable(
        positions,
      ),
      gem: gem,
      gems: List<Gem>.unmodifiable(
        gems,
      ),
      color: color,
      animationType: animationType,
      score: score,
      count: count,
      chain: chain,
    );
  }
}
