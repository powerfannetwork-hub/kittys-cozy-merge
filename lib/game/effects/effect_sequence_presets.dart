import 'package:flutter/material.dart';

import 'effect_sequence.dart';
import 'effect_sequence_factory.dart';
import 'game_animation_controller.dart';

class EffectSequencePresets {
  EffectSequencePresets._();

  static EffectSequence normalMatch({
    required Iterable<Offset> positions,
    Color color = Colors.white,
  }) {
    return EffectSequenceFactory.match(
      positions: positions,
      color: color,
    );
  }

  static EffectSequence invalidMove({
    required Offset position,
    Color color = Colors.white,
  }) {
    return EffectSequenceFactory.invalidMove(
      position: position,
      color: color,
    );
  }

  static EffectSequence rocketHorizontal({
    required Offset position,
    Color color = Colors.white,
  }) {
    return EffectSequenceFactory.rocket(
      position: position,
      horizontal: true,
      color: color,
    );
  }

  static EffectSequence rocketVertical({
    required Offset position,
    Color color = Colors.white,
  }) {
    return EffectSequenceFactory.rocket(
      position: position,
      horizontal: false,
      color: color,
    );
  }

  static EffectSequence bomb({
    required Offset position,
    Color color = Colors.white,
  }) {
    return EffectSequenceFactory.bomb(
      position: position,
      color: color,
    );
  }

  static EffectSequence colorBomb({
    required Offset position,
    Color color = Colors.white,
  }) {
    return EffectSequenceFactory.colorBomb(
      position: position,
      color: color,
    );
  }

  static EffectSequence swap({
    required Offset from,
    required Offset to,
  }) {
    return EffectSequenceFactory.swap(
      from: from,
      to: to,
    );
  }

  static EffectSequence swapBack({
    required Offset from,
    required Offset to,
  }) {
    return EffectSequenceFactory.swapBack(
      from: from,
      to: to,
    );
  }

  static EffectSequence matchAndCollect({
    required Iterable<Offset> positions,
    Color color = Colors.white,
  }) {
    return EffectSequenceFactory.matchThenCollect(
      matchPositions: positions,
      color: color,
    );
  }

  static EffectSequence matchAndFall({
    required Iterable<Offset> matchPositions,
    required Iterable<Offset> fallingPositions,
    Color color = Colors.white,
  }) {
    return EffectSequenceFactory.matchThenFall(
      matchPositions: matchPositions,
      fallingPositions: fallingPositions,
      color: color,
    );
  }

  static EffectSequence specialAndMatch({
    required Offset specialPosition,
    required Iterable<Offset> affectedPositions,
    Color color = Colors.white,
  }) {
    return EffectSequenceFactory.specialThenMatch(
      specialPosition: specialPosition,
      affectedPositions: affectedPositions,
      color: color,
    );
  }

  static EffectSequence rocketPlusRocket({
    required Offset firstPosition,
    required Offset secondPosition,
    Color color = Colors.white,
  }) {
    return EffectSequence(
      steps: [
        EffectSequenceStep(
          type: GameAnimationType.rocket,
          duration: const Duration(
            milliseconds: 280,
          ),
          positions: [
            firstPosition,
            secondPosition,
          ],
          color: color,
        ),
      ],
    );
  }

  static EffectSequence rocketPlusBomb({
    required Offset rocketPosition,
    required Offset bombPosition,
    Color color = Colors.white,
  }) {
    return EffectSequence(
      steps: [
        EffectSequenceStep(
          type: GameAnimationType.rocket,
          duration: const Duration(
            milliseconds: 280,
          ),
          position: rocketPosition,
          color: color,
        ),
        EffectSequenceStep(
          type: GameAnimationType.bomb,
          duration: const Duration(
            milliseconds: 320,
          ),
          position: bombPosition,
          color: color,
        ),
      ],
    );
  }

  static EffectSequence bombPlusBomb({
    required Offset firstPosition,
    required Offset secondPosition,
    Color color = Colors.white,
  }) {
    return EffectSequence(
      steps: [
        EffectSequenceStep(
          type: GameAnimationType.bomb,
          duration: const Duration(
            milliseconds: 320,
          ),
          positions: [
            firstPosition,
            secondPosition,
          ],
          color: color,
        ),
      ],
    );
  }

  static EffectSequence colorBombPlusGem({
    required Offset colorBombPosition,
    required Iterable<Offset> affectedPositions,
    Color color = Colors.white,
  }) {
    return EffectSequence(
      steps: [
        EffectSequenceStep(
          type: GameAnimationType.colorBomb,
          duration: const Duration(
            milliseconds: 360,
          ),
          position: colorBombPosition,
          color: color,
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

  static EffectSequence colorBombPlusColorBomb({
    required Offset firstPosition,
    required Offset secondPosition,
    Color color = Colors.white,
  }) {
    return EffectSequence(
      steps: [
        EffectSequenceStep(
          type: GameAnimationType.colorBomb,
          duration: const Duration(
            milliseconds: 420,
          ),
          positions: [
            firstPosition,
            secondPosition,
          ],
          color: color,
        ),
      ],
    );
  }

  static EffectSequence cascade({
    required List<Iterable<Offset>> matchGroups,
    Color color = Colors.white,
  }) {
    return EffectSequenceFactory.cascade(
      matchGroups: matchGroups,
      color: color,
    );
  }

  static EffectSequence goalComplete({
    required Offset position,
    Color color = Colors.white,
  }) {
    return EffectSequenceFactory.goalComplete(
      position: position,
      color: color,
    );
  }

  static EffectSequence completeMove({
    required Offset from,
    required Offset to,
    required Iterable<Offset> matchedPositions,
    Color color = Colors.white,
  }) {
    final matches = matchedPositions.toList(
      growable: false,
    );

    return EffectSequence(
      steps: [
        EffectSequenceStep(
          type: GameAnimationType.swap,
          duration: const Duration(
            milliseconds: 180,
          ),
          positions: [
            from,
            to,
          ],
        ),
        if (matches.isNotEmpty)
          EffectSequenceStep(
            type: GameAnimationType.gemMatch,
            duration: const Duration(
              milliseconds: 240,
            ),
            positions: matches,
            color: color,
          ),
        if (matches.isNotEmpty)
          EffectSequenceStep(
            type: GameAnimationType.gemCollect,
            duration: const Duration(
              milliseconds: 180,
            ),
            positions: matches,
            color: color,
          ),
      ],
    );
  }

  static EffectSequence rejectedMove({
    required Offset from,
    required Offset to,
    Color color = Colors.white,
  }) {
    return EffectSequence(
      steps: [
        EffectSequenceStep(
          type: GameAnimationType.swapBack,
          duration: const Duration(
            milliseconds: 180,
          ),
          positions: [
            from,
            to,
          ],
          color: color,
        ),
        EffectSequenceStep(
          type: GameAnimationType.invalidMove,
          duration: const Duration(
            milliseconds: 180,
          ),
          position: from,
          color: color,
        ),
      ],
    );
  }
}
