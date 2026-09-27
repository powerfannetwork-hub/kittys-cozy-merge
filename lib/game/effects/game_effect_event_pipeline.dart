import 'game_effect_event.dart';
import 'game_effect_event_controller.dart';
import 'game_effect_event_mapper.dart';
import 'effect_sequence_controller.dart';
import 'effect_sequence_runner.dart';
import 'game_effect_manager.dart';

class GameEffectEventPipeline {
  GameEffectEventPipeline({
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
      _handleEventChanged,
    );

    _sequenceController.addListener(
      _handleSequenceChanged,
    );
  }

  final GameEffectEventController _eventController;
  final GameEffectEventMapper _eventMapper;
  final EffectSequenceController _sequenceController;
  final GameEffectManager _effectManager;
  final EffectSequenceRunner _sequenceRunner;

  bool _disposed = false;
  bool _processingEvent = false;

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
      _eventController.isRunning ||
      _sequenceController.isRunning;

  bool get isPaused =>
      _eventController.isPaused ||
      _sequenceController.isPaused;

  bool get isComplete =>
      _eventController.isCompleted;

  bool get isIdle =>
      !_eventController.isRunning &&
      !_eventController.isPaused &&
      !_sequenceController.isRunning &&
      !_sequenceController.isPaused;

  int get currentEventIndex =>
      _eventController.currentIndex;

  int get eventCount =>
      _eventController.length;

  GameEffectEvent? get currentEvent =>
      _eventController.current;

  void load(
    Iterable<GameEffectEvent> events,
  ) {
    _ensureActive();

    _processingEvent = false;
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

    if (_eventController.isEmpty) {
      return;
    }

    _processingEvent = false;

    _eventController.start();

    _processCurrentEvent();
  }

  void pause() {
    _ensureActive();

    if (_sequenceController.isRunning) {
      _sequenceRunner.pause();
    }

    _eventController.pause();
  }

  void resume() {
    _ensureActive();

    if (_eventController.isPaused) {
      _eventController.resume();
    }

    if (_sequenceController.isPaused) {
      _sequenceRunner.resume();
    }

    _processCurrentEvent();
  }

  void next() {
    _ensureActive();

    _processingEvent = false;

    _sequenceRunner.stop();

    _eventController.nextEvent();

    _processCurrentEvent();
  }

  void skipCurrent() {
    _ensureActive();

    _processingEvent = false;

    _sequenceRunner.stop();

    if (_eventController.isRunning) {
      _eventController.nextEvent();
    }

    _processCurrentEvent();
  }

  void completeCurrent() {
    _ensureActive();

    if (_sequenceController.isRunning) {
      _sequenceRunner.completeCurrent();
      return;
    }

    if (_eventController.isRunning) {
      _eventController.completeCurrent();
      _processCurrentEvent();
    }
  }

  void stop() {
    _ensureActive();

    _processingEvent = false;

    _sequenceRunner.stop();
    _eventController.stop();
  }

  void reset() {
    _ensureActive();

    _processingEvent = false;

    _sequenceRunner.reset();
    _eventController.reset();
  }

  void clear() {
    _ensureActive();

    _processingEvent = false;

    _sequenceRunner.clear();
    _eventController.clear();
  }

  void _handleEventChanged() {
    if (_disposed) {
      return;
    }

    _processCurrentEvent();
  }

  void _handleSequenceChanged() {
    if (_disposed) {
      return;
    }

    if (_sequenceController.isComplete) {
      _completeSequenceAndAdvanceEvent();
    }
  }

  void _processCurrentEvent() {
    if (_disposed ||
        _processingEvent) {
      return;
    }

    if (!_eventController.isRunning) {
      return;
    }

    final event = _eventController.current;

    if (event == null) {
      return;
    }

    _processingEvent = true;

    final sequence = _eventMapper.map(event);

    if (sequence.isEmpty) {
      _processingEvent = false;

      _eventController.nextEvent();

      return;
    }

    _sequenceRunner.load(sequence);
    _sequenceRunner.start();

    _processingEvent = false;
  }

  void _completeSequenceAndAdvanceEvent() {
    if (_disposed ||
        !_eventController.isRunning) {
      return;
    }

    if (_processingEvent) {
      return;
    }

    _processingEvent = true;

    _sequenceRunner.stop();

    _eventController.nextEvent();

    _processingEvent = false;

    if (_eventController.isRunning) {
      _processCurrentEvent();
    }
  }

  void _ensureActive() {
    if (_disposed) {
      throw StateError(
        'GameEffectEventPipeline has already been disposed.',
      );
    }
  }

  void dispose() {
    if (_disposed) {
      return;
    }

    _disposed = true;

    _eventController.removeListener(
      _handleEventChanged,
    );

    _sequenceController.removeListener(
      _handleSequenceChanged,
    );

    _sequenceRunner.dispose();
  }
}
