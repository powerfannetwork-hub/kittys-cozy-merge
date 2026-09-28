import 'package:flutter/material.dart';

import 'effect_position_mapper.dart';
import 'effect_sequence_controller.dart';
import 'game_effect_dispatcher.dart';
import 'game_effect_event_controller.dart';
import 'game_effect_event_mapper.dart';
import 'game_effect_event_pipeline.dart';
import 'game_effect_manager.dart';
import '../gameplay/gameplay_effect_coordinator.dart';

class GameplayEffectRuntime {
  GameplayEffectRuntime({
    required int rows,
    required int columns,
    required double cellSize,
    Offset origin = Offset.zero,
    Duration effectStepInterval =
        const Duration(milliseconds: 120),
  }) : positionMapper = EffectPositionMapper(
          rows: rows,
          columns: columns,
          cellSize: cellSize,
          origin: origin,
        ) {
    eventController =
        GameEffectEventController();

    eventMapper = GameEffectEventMapper(
      positionMapper: positionMapper,
    );

    sequenceController =
        EffectSequenceController(
      stepInterval: effectStepInterval,
    );

    effectManager =
        GameEffectManager();

    pipeline =
        GameEffectEventPipeline(
      eventController: eventController,
      eventMapper: eventMapper,
      sequenceController: sequenceController,
      effectManager: effectManager,
    );

    dispatcher =
        GameEffectDispatcher(
      pipeline: pipeline,
    );

    coordinator =
        GameplayEffectCoordinator(
      dispatcher: dispatcher,
    );
  }

  final EffectPositionMapper positionMapper;

  late final GameEffectEventController
      eventController;

  late final GameEffectEventMapper eventMapper;

  late final EffectSequenceController
      sequenceController;

  late final GameEffectManager effectManager;

  late final GameEffectEventPipeline
      pipeline;

  late final GameEffectDispatcher dispatcher;

  late final GameplayEffectCoordinator
      coordinator;

  bool _disposed = false;

  bool get isDisposed => _disposed;

  bool get isRunning =>
      coordinator.isRunning;

  bool get isPaused =>
      coordinator.isPaused;

  bool get isComplete =>
      coordinator.isComplete;

  bool get isIdle =>
      coordinator.isIdle;

  void updateBoardGeometry({
    required int rows,
    required int columns,
    required double cellSize,
    Offset origin = Offset.zero,
  }) {
    _ensureActive();

    throw UnsupportedError(
      'Create a new GameplayEffectRuntime when board geometry changes.',
    );
  }

  void reset() {
    _ensureActive();

    coordinator.reset();
    effectManager.reset();
  }

  void clear() {
    _ensureActive();

    coordinator.clear();
    effectManager.clearVisualEffects();
  }

  void stop() {
    _ensureActive();

    coordinator.stop();
    effectManager.clearVisualEffects();
  }

  void dispose() {
    if (_disposed) {
      return;
    }

    _disposed = true;

    dispatcher.dispose();
    sequenceController.dispose();
    eventController.dispose();
    effectManager.dispose();
  }

  void _ensureActive() {
    if (_disposed) {
      throw StateError(
        'GameplayEffectRuntime has already been disposed.',
      );
    }
  }
}
