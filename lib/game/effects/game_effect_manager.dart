import 'package:flutter/foundation.dart';

import 'game_animation_controller.dart';
import 'gem_effect.dart';
import 'gem_effect_controller.dart';
import 'move_effects.dart';

class GameEffectManager extends ChangeNotifier {
  GameEffectManager({
    GameAnimationController? animationController,
    GemEffectController? gemEffectController,
    MoveEffects? moveEffects,
  })  : _animationController =
            animationController ?? GameAnimationController(),
        _gemEffectController =
            gemEffectController ?? GemEffectController(),
        _moveEffects = moveEffects ?? MoveEffects();

  final GameAnimationController _animationController;
  final GemEffectController _gemEffectController;
  final MoveEffects _moveEffects;

  GameAnimationController get animationController =>
      _animationController;

  GemEffectController get gemEffectController =>
      _gemEffectController;

  MoveEffects get moveEffects => _moveEffects;

  bool get hasActiveAnimation =>
      _animationController.isRunning;

  bool get hasGemEffects =>
      _gemEffectController.hasEffects;

  bool get hasMoveEffects =>
      !_moveEffects.isEmpty;

  bool get isIdle =>
      !hasActiveAnimation &&
      !hasGemEffects &&
      !hasMoveEffects;

  GameAnimationRequest? get currentAnimation =>
      _animationController.currentRequest;

  List<GemEffect> get gemEffects =>
      _gemEffectController.effects;

  List<MoveEffect> get moveEffectQueue =>
      _moveEffects.effects;

  void playAnimation(
    GameAnimationType type, {
    Duration? duration,
    Duration? delay,
    double intensity = 1.0,
  }) {
    _animationController.start(
      type,
      duration: duration,
      delay: delay,
      intensity: intensity,
    );

    notifyListeners();
  }

  void updateAnimationProgress(
    double progress,
  ) {
    _animationController.updateProgress(
      progress,
    );

    notifyListeners();
  }

  void completeAnimation() {
    _animationController.complete();

    notifyListeners();
  }

  void cancelAnimation() {
    _animationController.cancel();

    notifyListeners();
  }

  void addGemEffect(
    GemEffect effect,
  ) {
    _gemEffectController.addEffect(
      effect,
    );

    notifyListeners();
  }

  void addGemEffects(
    Iterable<GemEffect> effects,
  ) {
    _gemEffectController.addEffects(
      effects,
    );

    notifyListeners();
  }

  void clearGemEffects() {
    _gemEffectController.clear();

    notifyListeners();
  }

  void addMoveEffect(
    MoveEffect effect,
  ) {
    _moveEffects.add(
      effect,
    );

    notifyListeners();
  }

  void addMoveEffects(
    Iterable<MoveEffect> effects,
  ) {
    _moveEffects.addAll(
      effects,
    );

    notifyListeners();
  }

  void startMoveEffects() {
    _moveEffects.start();

    notifyListeners();
  }

  MoveEffect? nextMoveEffect() {
    final effect = _moveEffects.next();

    notifyListeners();

    return effect;
  }

  void finishCurrentMoveEffect() {
    _moveEffects.finishCurrent();

    notifyListeners();
  }

  void stopMoveEffects() {
    _moveEffects.stop();

    notifyListeners();
  }

  void clearMoveEffects() {
    _moveEffects.clear();

    notifyListeners();
  }

  void reset() {
    _animationController.reset();
    _gemEffectController.clear();
    _moveEffects.reset();

    notifyListeners();
  }

  void clearVisualEffects() {
    _animationController.cancel();
    _gemEffectController.clear();
    _moveEffects.clear();

    notifyListeners();
  }

  void playMatch({
    required Offset position,
    required Color color,
  }) {
    playAnimation(
      GameAnimationType.gemMatch,
    );

    _gemEffectController.match(
      position: position,
      color: color,
    );

    notifyListeners();
  }

  void playRocketHorizontal({
    required Offset position,
    required Color color,
  }) {
    playAnimation(
      GameAnimationType.rocket,
    );

    _gemEffectController.rocketHorizontal(
      position: position,
      color: color,
    );

    notifyListeners();
  }

  void playRocketVertical({
    required Offset position,
    required Color color,
  }) {
    playAnimation(
      GameAnimationType.rocket,
    );

    _gemEffectController.rocketVertical(
      position: position,
      color: color,
    );

    notifyListeners();
  }

  void playBomb({
    required Offset position,
    required Color color,
  }) {
    playAnimation(
      GameAnimationType.bomb,
    );

    _gemEffectController.bomb(
      position: position,
      color: color,
    );

    notifyListeners();
  }

  void playColorBomb({
    required Offset position,
    required Color color,
  }) {
    playAnimation(
      GameAnimationType.colorBomb,
    );

    _gemEffectController.colorBomb(
      position: position,
      color: color,
    );

    notifyListeners();
  }

  void playSparkle({
    required Offset position,
    required Color color,
  }) {
    _gemEffectController.sparkle(
      position: position,
      color: color,
    );

    notifyListeners();
  }

  void playSwap() {
    playAnimation(
      GameAnimationType.swap,
    );
  }

  void playSwapBack() {
    playAnimation(
      GameAnimationType.swapBack,
    );
  }

  void playInvalidMove() {
    playAnimation(
      GameAnimationType.invalidMove,
    );
  }

  void playGoalComplete() {
    playAnimation(
      GameAnimationType.goalComplete,
    );
  }

  void playSpecialGem() {
    playAnimation(
      GameAnimationType.specialGem,
    );
  }

  void playGemCollect() {
    playAnimation(
      GameAnimationType.gemCollect,
    );
  }

  void playGemFall() {
    playAnimation(
      GameAnimationType.gemFall,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _gemEffectController.dispose();
    _moveEffects.dispose();

    super.dispose();
  }
}
