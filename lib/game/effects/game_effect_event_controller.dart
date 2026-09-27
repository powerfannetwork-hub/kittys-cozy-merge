import 'package:flutter/foundation.dart';

import 'game_effect_event.dart';

class GameEffectEventController extends ChangeNotifier {
  GameEffectEventController({
    Iterable<GameEffectEvent> events =
        const <GameEffectEvent>[],
  }) : _events = List<GameEffectEvent>.from(events);

  final List<GameEffectEvent> _events;

  int _currentIndex = -1;
  bool _started = false;
  bool _paused = false;
  bool _completed = false;

  List<GameEffectEvent> get events =>
      List<GameEffectEvent>.unmodifiable(_events);

  int get length => _events.length;

  int get currentIndex => _currentIndex;

  bool get isEmpty => _events.isEmpty;

  bool get isStarted => _started;

  bool get isPaused => _paused;

  bool get isCompleted => _completed;

  bool get isRunning =>
      _started &&
      !_paused &&
      !_completed &&
      _events.isNotEmpty;

  bool get isIdle =>
      !_started || _completed || _events.isEmpty;

  GameEffectEvent? get current {
    if (_currentIndex < 0 ||
        _currentIndex >= _events.length) {
      return null;
    }

    return _events[_currentIndex];
  }

  GameEffectEvent? get next {
    final nextIndex = _currentIndex + 1;

    if (nextIndex < 0 ||
        nextIndex >= _events.length) {
      return null;
    }

    return _events[nextIndex];
  }

  void add(GameEffectEvent event) {
    if (_started) {
      throw StateError(
        'Cannot add an event after processing has started.',
      );
    }

    _events.add(event);
    notifyListeners();
  }

  void addAll(
    Iterable<GameEffectEvent> events,
  ) {
    if (_started) {
      throw StateError(
        'Cannot add events after processing has started.',
      );
    }

    _events.addAll(events);
    notifyListeners();
  }

  void load(
    Iterable<GameEffectEvent> events,
  ) {
    _events
      ..clear()
      ..addAll(events);

    _currentIndex = -1;
    _started = false;
    _paused = false;
    _completed = false;

    notifyListeners();
  }

  void start() {
    if (_events.isEmpty) {
      _started = true;
      _paused = false;
      _completed = true;
      _currentIndex = -1;

      notifyListeners();
      return;
    }

    _started = true;
    _paused = false;
    _completed = false;
    _currentIndex = 0;

    notifyListeners();
  }

  GameEffectEvent? nextEvent() {
    if (!_started) {
      start();
      return current;
    }

    if (_paused || _completed) {
      return null;
    }

    final nextIndex = _currentIndex + 1;

    if (nextIndex >= _events.length) {
      _completed = true;
      _paused = false;

      notifyListeners();
      return null;
    }

    _currentIndex = nextIndex;

    notifyListeners();

    return current;
  }

  void completeCurrent() {
    if (!_started ||
        _paused ||
        _completed) {
      return;
    }

    final nextIndex = _currentIndex + 1;

    if (nextIndex >= _events.length) {
      _completed = true;
      _paused = false;

      notifyListeners();
      return;
    }

    _currentIndex = nextIndex;

    notifyListeners();
  }

  void pause() {
    if (!_started ||
        _completed ||
        _paused) {
      return;
    }

    _paused = true;

    notifyListeners();
  }

  void resume() {
    if (!_started ||
        _completed ||
        !_paused) {
      return;
    }

    _paused = false;

    notifyListeners();
  }

  void stop() {
    _started = false;
    _paused = false;
    _completed = false;
    _currentIndex = -1;

    notifyListeners();
  }

  void reset() {
    _currentIndex = -1;
    _started = false;
    _paused = false;
    _completed = false;

    notifyListeners();
  }

  void clear() {
    if (_events.isEmpty &&
        _currentIndex == -1 &&
        !_started &&
        !_paused &&
        !_completed) {
      return;
    }

    _events.clear();
    _currentIndex = -1;
    _started = false;
    _paused = false;
    _completed = false;

    notifyListeners();
  }

  GameEffectEvent? eventAt(int index) {
    if (index < 0 ||
        index >= _events.length) {
      throw RangeError.index(
        index,
        _events,
        'index',
        'Event index is outside the event queue.',
      );
    }

    return _events[index];
  }

  bool hasEventAt(int index) {
    return index >= 0 &&
        index < _events.length;
  }

  @override
  String toString() {
    return 'GameEffectEventController('
        'length: $length, '
        'currentIndex: $currentIndex, '
        'started: $isStarted, '
        'paused: $isPaused, '
        'completed: $isCompleted'
        ')';
  }
}
