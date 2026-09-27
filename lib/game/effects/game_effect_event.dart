import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../board/board_position.dart';
import '../gems/gem.dart';
import 'game_animation_controller.dart';

enum GameEffectEventType {
  swap,
  swapBack,
  match,
  gemRemoved,
  gemCollected,
  gemFall,
  specialGemCreated,
  specialGemActivated,
  cascade,
  goalComplete,
  invalidMove,
}

@immutable
class GameEffectEvent {
  const GameEffectEvent({
    required this.type,
    this.from,
    this.to,
    this.position,
    this.positions = const <BoardPosition>[],
    this.gem,
    this.gems = const <Gem>[],
    this.color = Colors.white,
    this.animationType,
    this.score = 0,
    this.count = 0,
    this.chain = 0,
  });

  final GameEffectEventType type;

  final BoardPosition? from;
  final BoardPosition? to;

  final BoardPosition? position;
  final List<BoardPosition> positions;

  final Gem? gem;
  final List<Gem> gems;

  final Color color;

  final GameAnimationType? animationType;

  final int score;
  final int count;
  final int chain;

  bool get hasSwap =>
      from != null && to != null;

  bool get hasPosition =>
      position != null;

  bool get hasPositions =>
      positions.isNotEmpty;

  bool get hasGem =>
      gem != null;

  bool get hasGems =>
      gems.isNotEmpty;

  bool get hasScore =>
      score > 0;

  bool get hasCount =>
      count > 0;

  bool get hasChain =>
      chain > 0;

  GameEffectEvent copyWith({
    GameEffectEventType? type,
    BoardPosition? from,
    BoardPosition? to,
    BoardPosition? position,
    List<BoardPosition>? positions,
    Gem? gem,
    List<Gem>? gems,
    Color? color,
    GameAnimationType? animationType,
    int? score,
    int? count,
    int? chain,
  }) {
    return GameEffectEvent(
      type: type ?? this.type,
      from: from ?? this.from,
      to: to ?? this.to,
      position: position ?? this.position,
      positions: positions ?? this.positions,
      gem: gem ?? this.gem,
      gems: gems ?? this.gems,
      color: color ?? this.color,
      animationType:
          animationType ?? this.animationType,
      score: score ?? this.score,
      count: count ?? this.count,
      chain: chain ?? this.chain,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! GameEffectEvent) {
      return false;
    }

    return other.type == type &&
        other.from == from &&
        other.to == to &&
        other.position == position &&
        listEquals(
          other.positions,
          positions,
        ) &&
        other.gem == gem &&
        listEquals(
          other.gems,
          gems,
        ) &&
        other.color == color &&
        other.animationType ==
            animationType &&
        other.score == score &&
        other.count == count &&
        other.chain == chain;
  }

  @override
  int get hashCode {
    return Object.hash(
      type,
      from,
      to,
      position,
      Object.hashAll(positions),
      gem,
      Object.hashAll(gems),
      color,
      animationType,
      score,
      count,
      chain,
    );
  }

  @override
  String toString() {
    return 'GameEffectEvent('
        'type: $type, '
        'from: $from, '
        'to: $to, '
        'position: $position, '
        'positions: $positions, '
        'score: $score, '
        'count: $count, '
        'chain: $chain'
        ')';
  }
}
