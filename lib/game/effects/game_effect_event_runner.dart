import 'game_effect_event.dart';
import 'game_effect_event_controller.dart';
import 'game_effect_event_mapper.dart';
import 'effect_sequence.dart';
import 'effect_sequence_controller.dart';
import 'effect_sequence_runner.dart';
import 'game_effect_manager.dart';

class GameEffectEventRunner {
  GameEffectEventRunner({
    required GameEffectEventController eventController,
    required GameEffectEventMapper eventMapper,
    required EffectSequenceController sequenceController,
    required GameEffectManager effectManager,
  })  : _eventController = eventController,
        _eventMapper = eventMapper,
        _sequenceController = sequenceController,
        _effectManager = effectManager,
        _sequenceRunner = EffectSequenceRunner(
          sequenceController: sequenceController,
          effectManager: effectManager,
        ) {
    _eventController.addListener(
      _handleEventControllerChanged,
    );
  }

  final GameEffectEventController _eventController;
  final GameEffectEventMapper _eventMapper;
  final EffectSequenceController _sequenceController;
  final GameEffectManager _effectManager;
  final EffectSequenceRunner _sequenceRunner;

  bool _disposed = false;
  int _lastExecutedEventIndex = -1;

  GameEffectEventController get eventController =>
      _eventController;

  GameEffectEventMapper get eventMapper =>
      _eventMapper;

  EffectSequenceController get sequenceController =>
      _sequenceController;

  GameEffectManager get effectManager =>
      _effectManager;

  EffectSequenceRunner get sequenceRunner =>
      _sequenceRunner;

  bool get isRunning =>
      _eventController.isRunning;

  bool get isPaused =>
      _eventController.isPaused;

  bool get isComplete =>
      _eventController.isCompleted;

  bool get isIdle =>
      _eventController.isIdle;

  int get currentIndex =>
      _eventController.currentIndex;

  int get length =>
      _eventController.length;

  GameEffectEvent? get currentEvent =>
      _eventController.current;

  EffectSequenceStep? get currentSequenceStep =>
      _sequenceRunner.currentStep;

  void load(
    Iterable<GameEffectEvent> events,
  ) {
    _ensureActive();

    _lastExecutedEventIndex = -1;

    _sequenceRunner.stop();
    _eventController.load(events);
  }

  void add(
    GameEffectEvent event,
  ) {
    _ensureActive();

    _eventController.add(event);
  }

  void addAll(
    Iterable<GameEffectEvent> events,
  ) {
    _ensureActive();

    _eventController.addAll(events);
  }

  void start() {
    _ensureActive();

    _lastExecutedEventIndex = -1;

    _eventController.start();

    _executeCurrentEvent();
  }

  void pause() {
    _ensureActive();

    _sequenceRunner.pause();
    _eventController.pause();
  }

  void resume() {
    _ensureActive();

    _eventController.resume();
    _sequenceRunner.resume();

    _executeCurrentEvent();
  }

  void next() {
    _ensureActive();

    _sequenceRunner.stop();

    _eventController.nextEvent();

    _executeCurrentEvent();
  }

  void completeCurrent() {
    _ensureActive();

    _sequenceRunner.completeCurrent();
    _eventController.completeCurrent();

    _executeCurrentEvent();
  }

  void stop() {
    _ensureActive();

    _sequenceRunner.stop();
    _eventController.stop();

    _lastExecutedEventIndex = -1;
  }

  void reset() {
    _ensureActive();

    _sequenceRunner.reset();
    _eventController.reset();

    _lastExecutedEventIndex = -1;
  }

  void clear() {
    _ensureActive();

    _sequenceRunner.clear();
    _eventController.clear();

    _lastExecutedEventIndex = -1;
  }

  void _handleEventControllerChanged() {
    if (_disposed) {
      return;
    }

    _executeCurrentEvent();
  }

  void _executeCurrentEvent() {
    if (_disposed) {
      return;
    }

    final index = _eventController.currentIndex;

    if (index < 0) {
      return;
    }

    if (index == _lastExecutedEventIndex) {
      return;
    }

    final event = _eventController.current;

    if (event == null) {
      return;
    }

    _lastExecutedEventIndex = index;

    final sequence = _eventMapper.map(event);

    _runSequence(sequence);
  }

  void _runSequence(
    EffectSequence sequence,
  ) {
    if (sequence.isEmpty) {
      _advanceEventAfterEmptySequence();
      return;
    }

    _sequenceRunner.load(sequence);
    _sequenceRunner.start();
  }

  void _advanceEventAfterEmptySequence() {
    if (_disposed) {
      return;
    }

    if (!_eventController.isRunning) {
      return;
    }

    _eventController.nextEvent();
  }

  void _ensureActive() {
    if (_disposed) {
      throw StateError(
        'GameEffectEventRunner has already been disposed.',
      );
    }
  }

  void dispose() {
    if (_disposed) {
      return;
    }

    _disposed = true;

    _eventController.removeListener(
      _handleEventControllerChanged,
    );

    _sequenceRunner.dispose();
  }
}
