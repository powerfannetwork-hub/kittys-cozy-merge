import 'dart:async';

import 'package:flutter/foundation.dart';

import 'effect_sequence.dart';

class EffectSequenceController extends ChangeNotifier {
  EffectSequenceController({
    Duration stepInterval = const Duration(milliseconds: 120),
  }) : _stepInterval = stepInterval {
    if (stepInterval <= Duration.zero) {
      throw ArgumentError.value(
        stepInterval,
        'stepInterval',
        'Step interval must be greater than zero.',
      );
    }
  }

  final Duration _stepInterval;

  EffectSequence? _sequence;
  Timer? _timer;

  bool _isRunning = false;
  bool _isPaused = false;

  EffectSequence? get sequence => _sequence;

  Duration get stepInterval => _stepInterval;

  bool get isRunning => _isRunning;

  bool get isPaused => _isPaused;

  bool get isIdle => !_isRunning && !_isPaused;

  bool get isComplete =>
      _sequence?.isCompleted ?? false;

  int get currentIndex =>
      _sequence?.currentIndex ?? -1;

  int get length =>
      _sequence?.length ?? 0;

  EffectSequenceStep? get currentStep =>
      _sequence?.current;

  void load(EffectSequence sequence) {
    stop();

    _sequence = sequence;

    notifyListeners();
  }

  void start() {
    final sequence = _sequence;

    if (sequence == null) {
      throw StateError(
        'Cannot start an effect sequence before one is loaded.',
      );
    }

    if (sequence.isEmpty) {
      sequence.start();
      _isRunning = false;
      _isPaused = false;
      notifyListeners();
      return;
    }

    _timer?.cancel();

    sequence.reset();
    sequence.start();

    _isRunning = true;
    _isPaused = false;

    notifyListeners();

    _scheduleNextStep();
  }

  void pause() {
    if (!_isRunning) {
      return;
    }

    _timer?.cancel();
    _timer = null;

    _isRunning = false;
    _isPaused = true;

    notifyListeners();
  }

  void resume() {
    if (!_isPaused) {
      return;
    }

    final sequence = _sequence;

    if (sequence == null ||
        sequence.isCompleted) {
      _isPaused = false;
      notifyListeners();
      return;
    }

    _isPaused = false;
    _isRunning = true;

    notifyListeners();

    _scheduleNextStep();
  }

  void next() {
    final sequence = _sequence;

    if (sequence == null) {
      return;
    }

    if (!sequence.isStarted) {
      sequence.start();
    } else {
      sequence.advance();
    }

    if (sequence.isCompleted) {
      _finish();
      return;
    }

    notifyListeners();
  }

  void completeCurrent() {
    final sequence = _sequence;

    if (sequence == null ||
        sequence.isCompleted) {
      return;
    }

    sequence.completeCurrent();

    if (sequence.isCompleted) {
      _finish();
      return;
    }

    notifyListeners();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;

    _isRunning = false;
    _isPaused = false;

    notifyListeners();
  }

  void reset() {
    _timer?.cancel();
    _timer = null;

    _sequence?.reset();

    _isRunning = false;
    _isPaused = false;

    notifyListeners();
  }

  void clear() {
    _timer?.cancel();
    _timer = null;

    _sequence = null;

    _isRunning = false;
    _isPaused = false;

    notifyListeners();
  }

  void _scheduleNextStep() {
    _timer?.cancel();

    if (!_isRunning) {
      return;
    }

    final sequence = _sequence;

    if (sequence == null ||
        sequence.isCompleted) {
      _finish();
      return;
    }

    _timer = Timer(
      _stepDurationForCurrentStep(),
      _advanceAutomatically,
    );
  }

  void _advanceAutomatically() {
    _timer = null;

    if (!_isRunning) {
      return;
    }

    final sequence = _sequence;

    if (sequence == null) {
      _finish();
      return;
    }

    sequence.advance();

    if (sequence.isCompleted) {
      _finish();
      return;
    }

    notifyListeners();

    _scheduleNextStep();
  }

  Duration _stepDurationForCurrentStep() {
    final step = _sequence?.current;

    if (step?.duration != null &&
        step!.duration! > Duration.zero) {
      return step.duration!;
    }

    if (step?.delay != null &&
        step!.delay! > Duration.zero) {
      return step.delay!;
    }

    return _stepInterval;
  }

  void _finish() {
    _timer?.cancel();
    _timer = null;

    _isRunning = false;
    _isPaused = false;

    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}
