import 'package:flutter/foundation.dart';

import 'game_effect_event.dart';

@immutable
class GameEffectEventBatch {
  const GameEffectEventBatch({
    this.events = const <GameEffectEvent>[],
  });

  final List<GameEffectEvent> events;

  int get length => events.length;

  bool get isEmpty => events.isEmpty;

  bool get isNotEmpty => events.isNotEmpty;

  GameEffectEvent? get firstOrNull {
    if (events.isEmpty) {
      return null;
    }

    return events.first;
  }

  GameEffectEvent? get lastOrNull {
    if (events.isEmpty) {
      return null;
    }

    return events.last;
  }

  GameEffectEvent? eventAt(int index) {
    if (index < 0 || index >= events.length) {
      return null;
    }

    return events[index];
  }

  bool containsType(
    GameEffectEventType type,
  ) {
    return events.any(
      (event) => event.type == type,
    );
  }

  List<GameEffectEvent> eventsOfType(
    GameEffectEventType type,
  ) {
    return List<GameEffectEvent>.unmodifiable(
      events.where(
        (event) => event.type == type,
      ),
    );
  }

  GameEffectEventBatch copyWith({
    List<GameEffectEvent>? events,
  }) {
    return GameEffectEventBatch(
      events: events ?? this.events,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! GameEffectEventBatch) {
      return false;
    }

    return listEquals(
      other.events,
      events,
    );
  }

  @override
  int get hashCode {
    return Object.hashAll(events);
  }

  @override
  String toString() {
    return 'GameEffectEventBatch('
        'length: $length, '
        'events: $events'
        ')';
  }
}

class GameEffectEventBatchBuilder {
  GameEffectEventBatchBuilder();

  final List<GameEffectEvent> _events =
      <GameEffectEvent>[];

  bool get isEmpty => _events.isEmpty;

  bool get isNotEmpty => _events.isNotEmpty;

  int get length => _events.length;

  List<GameEffectEvent> get events =>
      List<GameEffectEvent>.unmodifiable(
        _events,
      );

  void add(
    GameEffectEvent event,
  ) {
    _events.add(event);
  }

  void addAll(
    Iterable<GameEffectEvent> events,
  ) {
    _events.addAll(events);
  }

  void insert(
    int index,
    GameEffectEvent event,
  ) {
    if (index < 0 || index > _events.length) {
      throw RangeError.index(
        index,
        _events,
        'index',
      );
    }

    _events.insert(
      index,
      event,
    );
  }

  bool remove(
    GameEffectEvent event,
  ) {
    return _events.remove(event);
  }

  void removeAt(int index) {
    if (index < 0 || index >= _events.length) {
      throw RangeError.index(
        index,
        _events,
        'index',
      );
    }

    _events.removeAt(index);
  }

  void clear() {
    _events.clear();
  }

  GameEffectEvent? eventAt(int index) {
    if (index < 0 || index >= _events.length) {
      return null;
    }

    return _events[index];
  }

  GameEffectEventBatch build() {
    return GameEffectEventBatch(
      events: List<GameEffectEvent>.unmodifiable(
        _events,
      ),
    );
  }

  GameEffectEventBatch buildAndClear() {
    final batch = build();
    clear();
    return batch;
  }

  @override
  String toString() {
    return 'GameEffectEventBatchBuilder('
        'length: $length'
        ')';
  }
}
