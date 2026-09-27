import 'package:flutter/foundation.dart';

import 'game_animation_controller.dart';
import 'gem_effect.dart';
import 'move_effects.dart';

class EffectSequence {
  EffectSequence({
    Iterable<EffectSequenceStep> steps =
        const <EffectSequenceStep>[],
  }) : _steps = List<EffectSequenceStep>.from(steps);

  final List<EffectSequenceStep> _steps;

  int _currentIndex = -1;
  bool _started = false;
  bool _completed = false;

  List<EffectSequenceStep> get steps =>
      List<EffectSequenceStep>.unmodifiable(_steps);

  int get length => _steps.length;

  int get currentIndex => _currentIndex;

  bool get isStarted => _started;

  bool get isCompleted => _completed;

  bool get isEmpty => _steps.isEmpty;

  bool get isRunning =>
      _started && !_completed && _steps.isNotEmpty;

  EffectSequenceStep? get current {
    if (_currentIndex < 0 ||
        _currentIndex >= _steps.length) {
      return null;
    }

    return _steps[_currentIndex];
  }

  EffectSequenceStep? get next {
    final nextIndex = _currentIndex + 1;

    if (nextIndex < 0 ||
        nextIndex >= _steps.length) {
      return null;
    }

    return _steps[nextIndex];
  }

  void add(EffectSequenceStep step) {
    if (_started) {
      throw StateError(
        'Cannot add a step after the sequence has started.',
      );
    }

    _steps.add(step);
  }

  void addAll(Iterable<EffectSequenceStep> steps) {
    if (_started) {
      throw StateError(
        'Cannot add steps after the sequence has started.',
      );
    }

    _steps.addAll(steps);
  }

  void start() {
    if (_steps.isEmpty) {
      _started = true;
      _completed = true;
      _currentIndex = -1;
      return;
    }

    _started = true;
    _completed = false;
    _currentIndex = 0;
  }

  EffectSequenceStep? advance() {
    if (!_started) {
      start();
      return current;
    }

    if (_completed) {
      return null;
    }

    final nextIndex = _currentIndex + 1;

    if (nextIndex >= _steps.length) {
      _completed = true;
      return null;
    }

    _currentIndex = nextIndex;
    return current;
  }

  void completeCurrent() {
    if (!_started || _completed) {
      return;
    }

    final nextIndex = _currentIndex + 1;

    if (nextIndex >= _steps.length) {
      _completed = true;
      return;
    }

    _currentIndex = nextIndex;
  }

  void reset() {
    _currentIndex = -1;
    _started = false;
    _completed = false;
  }

  @override
  String toString() {
    return 'EffectSequence('
        'length: $length, '
        'currentIndex: $currentIndex, '
        'started: $isStarted, '
        'completed: $isCompleted'
        ')';
  }
}

@immutable
class EffectSequenceStep {
  const EffectSequenceStep({
    required this.type,
    this.duration,
    this.delay,
    this.intensity = 1.0,
    this.position,
    this.positions = const <Offset>[],
    this.color,
    this.moveEffect,
    this.gemEffect,
  }) : assert(intensity >= 0);

  final GameAnimationType type;
  final Duration? duration;
  final Duration? delay;
  final double intensity;

  final Offset? position;
  final List<Offset> positions;

  final Color? color;

  final MoveEffect? moveEffect;
  final GemEffect? gemEffect;

  bool get hasPosition => position != null;

  bool get hasPositions => positions.isNotEmpty;

  bool get hasMoveEffect => moveEffect != null;

  bool get hasGemEffect => gemEffect != null;

  EffectSequenceStep copyWith({
    GameAnimationType? type,
    Duration? duration,
    Duration? delay,
    double? intensity,
    Offset? position,
    List<Offset>? positions,
    Color? color,
    MoveEffect? moveEffect,
    GemEffect? gemEffect,
  }) {
    return EffectSequenceStep(
      type: type ?? this.type,
      duration: duration ?? this.duration,
      delay: delay ?? this.delay,
      intensity: intensity ?? this.intensity,
      position: position ?? this.position,
      positions: positions ?? this.positions,
      color: color ?? this.color,
      moveEffect: moveEffect ?? this.moveEffect,
      gemEffect: gemEffect ?? this.gemEffect,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! EffectSequenceStep) {
      return false;
    }

    return other.type == type &&
        other.duration == duration &&
        other.delay == delay &&
        other.intensity == intensity &&
        other.position == position &&
        listEquals(other.positions, positions) &&
        other.color == color &&
        other.moveEffect == moveEffect &&
        other.gemEffect == gemEffect;
  }

  @override
  int get hashCode {
    return Object.hash(
      type,
      duration,
      delay,
      intensity,
      position,
      Object.hashAll(positions),
      color,
      moveEffect,
      gemEffect,
    );
  }

  @override
  String toString() {
    return 'EffectSequenceStep('
        'type: $type, '
        'duration: $duration, '
        'delay: $delay, '
        'intensity: $intensity, '
        'position: $position, '
        'positions: $positions, '
        'color: $color'
        ')';
  }
}
