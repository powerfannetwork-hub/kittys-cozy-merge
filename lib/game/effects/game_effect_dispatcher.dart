import 'game_effect_event.dart';
import 'game_effect_event_batch.dart';
import 'game_effect_event_pipeline.dart';

class GameEffectDispatcher {
  GameEffectDispatcher({
    required GameEffectEventPipeline pipeline,
  }) : _pipeline = pipeline;

  final GameEffectEventPipeline _pipeline;

  GameEffectEventPipeline get pipeline => _pipeline;

  bool get isRunning => _pipeline.isRunning;

  bool get isPaused => _pipeline.isPaused;

  bool get isComplete => _pipeline.isComplete;

  bool get isIdle => _pipeline.isIdle;

  int get currentEventIndex =>
      _pipeline.currentEventIndex;

  int get eventCount =>
      _pipeline.eventCount;

  GameEffectEvent? get currentEvent =>
      _pipeline.currentEvent;

  void dispatch(
    GameEffectEvent event,
  ) {
    _pipeline.load(
      <GameEffectEvent>[event],
    );

    _pipeline.start();
  }

  void dispatchBatch(
    GameEffectEventBatch batch,
  ) {
    if (batch.isEmpty) {
      return;
    }

    _pipeline.load(
      batch.events,
    );

    _pipeline.start();
  }

  void dispatchEvents(
    Iterable<GameEffectEvent> events,
  ) {
    final eventList =
        List<GameEffectEvent>.from(events);

    if (eventList.isEmpty) {
      return;
    }

    _pipeline.load(eventList);
    _pipeline.start();
  }

  void add(
    GameEffectEvent event,
  ) {
    _pipeline.add(event);
  }

  void addAll(
    Iterable<GameEffectEvent> events,
  ) {
    _pipeline.addAll(events);
  }

  void start() {
    _pipeline.start();
  }

  void pause() {
    _pipeline.pause();
  }

  void resume() {
    _pipeline.resume();
  }

  void next() {
    _pipeline.next();
  }

  void skipCurrent() {
    _pipeline.skipCurrent();
  }

  void completeCurrent() {
    _pipeline.completeCurrent();
  }

  void stop() {
    _pipeline.stop();
  }

  void reset() {
    _pipeline.reset();
  }

  void clear() {
    _pipeline.clear();
  }

  void dispose() {
    _pipeline.dispose();
  }
}
