import 'package:flutter/material.dart';

import 'effect_factory.dart';
import 'effect_sequence.dart';
import 'effect_sequence_controller.dart';
import 'game_animation_controller.dart';
import 'game_effect_manager.dart';
import 'gem_effect.dart';

class EffectSequenceRunner {
  EffectSequenceRunner({
    required EffectSequenceController sequenceController,
    required GameEffectManager effectManager,
  })  : _sequenceController = sequenceController,
        _effectManager = effectManager {
    _sequenceController.addListener(
      _handleSequenceChanged,
    );
  }

  final EffectSequenceController _sequenceController;
  final GameEffectManager _effectManager;

  int _lastExecutedIndex = -1;
  bool _disposed = false;

  EffectSequenceController get sequenceController =>
      _sequenceController;

  GameEffectManager get effectManager =>
      _effectManager;

  bool get isRunning =>
      _sequenceController.isRunning;

  bool get isComplete =>
      _sequenceController.isComplete;

  EffectSequenceStep? get currentStep =>
      _sequenceController.currentStep;

  void load(EffectSequence sequence) {
    _ensureActive();

    _lastExecutedIndex = -1;

    _sequenceController.load(sequence);
  }

  void start() {
    _ensureActive();

    _lastExecutedIndex = -1;

    _sequenceController.start();

    _executeCurrentStep();
  }

  void pause() {
    _ensureActive();

    _sequenceController.pause();
  }

  void resume() {
    _ensureActive();

    _sequenceController.resume();

    _executeCurrentStep();
  }

  void next() {
    _ensureActive();

    _sequenceController.next();

    _executeCurrentStep();
  }

  void completeCurrent() {
    _ensureActive();

    _sequenceController.completeCurrent();

    _executeCurrentStep();
  }

  void stop() {
    _ensureActive();

    _sequenceController.stop();
  }

  void reset() {
    _ensureActive();

    _lastExecutedIndex = -1;

    _sequenceController.reset();
  }

  void clear() {
    _ensureActive();

    _lastExecutedIndex = -1;

    _sequenceController.clear();
  }

  void _handleSequenceChanged() {
    if (_disposed) {
      return;
    }

    _executeCurrentStep();
  }

  void _executeCurrentStep() {
    if (_disposed) {
      return;
    }

    final index = _sequenceController.currentIndex;

    if (index < 0) {
      return;
    }

    if (index == _lastExecutedIndex) {
      return;
    }

    final step = _sequenceController.currentStep;

    if (step == null) {
      return;
    }

    _lastExecutedIndex = index;

    _executeStep(step);
  }

  void _executeStep(
    EffectSequenceStep step,
  ) {
    final color = step.color ?? Colors.white;

    final gemEffect = step.gemEffect;

    if (gemEffect != null) {
      _addGemEffect(
        gemEffect,
      );
    }

    if (step.hasPositions) {
      _addPositionEffects(
        step,
        color,
      );
    } else if (step.hasPosition) {
      _addPositionEffect(
        step,
        step.position!,
        color,
      );
    }

    final moveEffect = step.moveEffect;

    if (moveEffect != null) {
      _effectManager.addMoveEffect(
        moveEffect,
      );
    }

    _playAnimationForStep(
      step,
    );
  }

  void _addGemEffect(
    GemEffect effect,
  ) {
    _effectManager.addGemEffect(
      effect,
    );
  }

  void _addPositionEffects(
    EffectSequenceStep step,
    Color color,
  ) {
    for (final position in step.positions) {
      _addPositionEffect(
        step,
        position,
        color,
      );
    }
  }

  void _addPositionEffect(
    EffectSequenceStep step,
    Offset position,
    Color color,
  ) {
    final effect = _createPositionEffect(
      step.type,
      position,
      color,
    );

    if (effect == null) {
      return;
    }

    _effectManager.addGemEffect(
      effect,
    );
  }

  GemEffect? _createPositionEffect(
    GameAnimationType type,
    Offset position,
    Color color,
  ) {
    switch (type) {
      case GameAnimationType.gemMatch:
        return EffectFactory.match(
          position: position,
          color: color,
        );

      case GameAnimationType.rocket:
        return EffectFactory.rocketHorizontal(
          position: position,
          color: color,
        );

      case GameAnimationType.bomb:
        return EffectFactory.bomb(
          position: position,
          color: color,
        );

      case GameAnimationType.colorBomb:
        return EffectFactory.colorBomb(
          position: position,
          color: color,
        );

      case GameAnimationType.gemCollect:
      case GameAnimationType.gemFall:
      case GameAnimationType.swap:
      case GameAnimationType.swapBack:
      case GameAnimationType.specialGem:
      case GameAnimationType.invalidMove:
      case GameAnimationType.goalComplete:
        return EffectFactory.sparkle(
          position: position,
          color: color,
        );
    }
  }

  void _playAnimationForStep(
    EffectSequenceStep step,
  ) {
    _effectManager.playAnimation(
      step.type,
      duration: step.duration,
      delay: step.delay,
      intensity: step.intensity,
    );
  }

  void _ensureActive() {
    if (_disposed) {
      throw StateError(
        'EffectSequenceRunner has already been disposed.',
      );
    }
  }

  void dispose() {
    if (_disposed) {
      return;
    }

    _disposed = true;

    _sequenceController.removeListener(
      _handleSequenceChanged,
    );
  }
}
