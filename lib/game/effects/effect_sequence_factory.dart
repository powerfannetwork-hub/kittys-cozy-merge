import 'package:flutter/material.dart';

import 'effect_factory.dart';
import 'effect_sequence.dart';
import 'game_animation_controller.dart';

class EffectSequenceFactory {
  EffectSequenceFactory._();

  static EffectSequence swap({
    required Offset from,
    required Offset to,
    Duration duration = const Duration(milliseconds: 180),
  }) {
    return EffectSequence(
      steps: [
        EffectSequenceStep(
          type: GameAnimationType.swap,
          duration: duration,
          positions: [
            from,
            to,
          ],
        ),
      ],
    );
  }

  static EffectSequence swapBack({
    required Offset from,
    required Offset to,
    Duration duration = const Duration(milliseconds: 180),
  }) {
    return EffectSequence(
      steps: [
        EffectSequenceStep(
          type: GameAnimationType.swapBack,
          duration: duration,
          positions: [
            from,
            to,
          ],
        ),
      ],
    );
  }

  static EffectSequence match({
    required Iterable<Offset> positions,
    Color color = Colors.white,
    Duration duration = const Duration(milliseconds: 240),
  }) {
    return EffectSequence(
      steps: [
        EffectSequenceStep(
          type: GameAnimationType.gemMatch,
          duration: duration,
          positions: positions.toList(
            growable: false,
          ),
          color: color,
        ),
      ],
    );
  }

  static EffectSequence rocket({
    required Offset position,
    bool horizontal = true,
    Color color = Colors.white,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return EffectSequence(
      steps: [
        EffectSequenceStep(
          type: GameAnimationType.rocket,
          duration: duration,
          position: position,
          color: color,
          gemEffect: horizontal
              ? EffectFactory.rocketHorizontal(
                  position: position,
                  color: color,
                )
              : EffectFactory.rocketVertical(
                  position: position,
                  color: color,
                ),
        ),
      ],
    );
  }

  static EffectSequence bomb({
    required Offset position,
    Color color = Colors.white,
    Duration duration = const Duration(milliseconds: 320),
  }) {
    return EffectSequence(
      steps: [
        EffectSequenceStep(
          type: GameAnimationType.bomb,
          duration: duration,
          position: position,
          color: color,
          gemEffect: EffectFactory.bomb(
            position: position,
            color: color,
          ),
        ),
      ],
    );
  }

  static EffectSequence colorBomb({
    required Offset position,
    Color color = Colors.white,
    Duration duration = const Duration(milliseconds: 360),
  }) {
    return EffectSequence(
      steps: [
        EffectSequenceStep(
          type: GameAnimationType.colorBomb,
          duration: duration,
          position: position,
          color: color,
          gemEffect: EffectFactory.colorBomb(
            position: position,
            color: color,
          ),
        ),
      ],
    );
  }

  static EffectSequence sparkle({
    required Iterable<Offset> positions,
    Color color = Colors.white,
    Duration duration = const Duration(milliseconds: 220),
  }) {
    return EffectSequence(
      steps: [
        EffectSequenceStep(
          type: GameAnimationType.gemCollect,
          duration: duration,
          positions: positions.toList(
            growable: false,
          ),
          color: color,
        ),
      ],
    );
  }

  static EffectSequence goalComplete({
    required Offset position,
    Color color = Colors.white,
    Duration duration = const Duration(milliseconds: 420),
  }) {
    return EffectSequence(
      steps: [
        EffectSequenceStep(
          type: GameAnimationType.goalComplete,
          duration: duration,
          position: position,
          color: color,
          gemEffect: EffectFactory.sparkle(
            position: position,
            color: color,
          ),
        ),
      ],
    );
  }

  static EffectSequence invalidMove({
    required Offset position,
    Color color = Colors.white,
    Duration duration = const Duration(milliseconds: 180),
  }) {
    return EffectSequence(
      steps: [
        EffectSequenceStep(
          type: GameAnimationType.invalidMove,
          duration: duration,
          position: position,
          color: color,
        ),
      ],
    );
  }

  static EffectSequence matchThenCollect({
    required Iterable<Offset> matchPositions,
    Color color = Colors.white,
  }) {
    final positions = matchPositions.toList(
      growable: false,
    );

    return EffectSequence(
      steps: [
        EffectSequenceStep(
          type: GameAnimationType.gemMatch,
          duration: const Duration(
            milliseconds: 240,
          ),
          positions: positions,
          color: color,
        ),
        EffectSequenceStep(
          type: GameAnimationType.gemCollect,
          duration: const Duration(
            milliseconds: 180,
          ),
          positions: positions,
          color: color,
        ),
      ],
    );
  }

  static EffectSequence matchThenFall({
    required Iterable<Offset> matchPositions,
    required Iterable<Offset> fallingPositions,
    Color color = Colors.white,
  }) {
    return EffectSequence(
      steps: [
        EffectSequenceStep(
          type: GameAnimationType.gemMatch,
          duration: const Duration(
            milliseconds: 240,
          ),
          positions: matchPositions.toList(
            growable: false,
          ),
          color: color,
        ),
        EffectSequenceStep(
          type: GameAnimationType.gemFall,
          duration: const Duration(
            milliseconds: 260,
          ),
          positions: fallingPositions.toList(
            growable: false,
          ),
          color: color,
        ),
      ],
    );
  }

  static EffectSequence specialThenMatch({
    required Offset specialPosition,
    required Iterable<Offset> affectedPositions,
    GameAnimationType specialType =
        GameAnimationType.specialGem,
    Color color = Colors.white,
  }) {
    return EffectSequence(
      steps: [
        EffectSequenceStep(
          type: specialType,
          duration: const Duration(
            milliseconds: 260,
          ),
          position: specialPosition,
          color: color,
          gemEffect: EffectFactory.sparkle(
            position: specialPosition,
            color: color,
          ),
        ),
        EffectSequenceStep(
          type: GameAnimationType.gemMatch,
          duration: const Duration(
            milliseconds: 260,
          ),
          positions: affectedPositions.toList(
            growable: false,
          ),
          color: color,
        ),
      ],
    );
  }

  static EffectSequence cascade({
    required List<Iterable<Offset>> matchGroups,
    Color color = Colors.white,
  }) {
    final steps = <EffectSequenceStep>[];

    for (int index = 0;
        index < matchGroups.length;
        index++) {
      final positions = matchGroups[index].toList(
        growable: false,
      );

      if (positions.isEmpty) {
        continue;
      }

      steps.add(
        EffectSequenceStep(
          type: GameAnimationType.gemMatch,
          duration: const Duration(
            milliseconds: 220,
          ),
          delay: Duration(
            milliseconds: index * 80,
          ),
          positions: positions,
          color: color,
        ),
      );
    }

    return EffectSequence(
      steps: steps,
    );
  }
}
