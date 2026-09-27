import 'package:flutter/material.dart';

import 'gem_effect.dart';

class EffectFactory {
  EffectFactory._();

  static GemEffect match({
    required Offset position,
    Color color = Colors.white,
  }) {
    return GemEffect(
      position: position,
      type: GemEffectType.match,
      color: color,
    );
  }

  static GemEffect rocketHorizontal({
    required Offset position,
    Color color = Colors.white,
  }) {
    return GemEffect(
      position: position,
      type: GemEffectType.rocketHorizontal,
      color: color,
    );
  }

  static GemEffect rocketVertical({
    required Offset position,
    Color color = Colors.white,
  }) {
    return GemEffect(
      position: position,
      type: GemEffectType.rocketVertical,
      color: color,
    );
  }

  static GemEffect bomb({
    required Offset position,
    Color color = Colors.white,
  }) {
    return GemEffect(
      position: position,
      type: GemEffectType.bomb,
      color: color,
    );
  }

  static GemEffect colorBomb({
    required Offset position,
    Color color = Colors.white,
  }) {
    return GemEffect(
      position: position,
      type: GemEffectType.colorBomb,
      color: color,
    );
  }

  static GemEffect sparkle({
    required Offset position,
    Color color = Colors.white,
  }) {
    return GemEffect(
      position: position,
      type: GemEffectType.sparkle,
      color: color,
    );
  }

  static GemEffect fromType({
    required Offset position,
    required GemEffectType type,
    Color color = Colors.white,
  }) {
    return GemEffect(
      position: position,
      type: type,
      color: color,
    );
  }

  static List<GemEffect> matches({
    required Iterable<Offset> positions,
    Color color = Colors.white,
  }) {
    return positions
        .map(
          (position) => match(
            position: position,
            color: color,
          ),
        )
        .toList(growable: false);
  }

  static List<GemEffect> sparkles({
    required Iterable<Offset> positions,
    Color color = Colors.white,
  }) {
    return positions
        .map(
          (position) => sparkle(
            position: position,
            color: color,
          ),
        )
        .toList(growable: false);
  }
}
