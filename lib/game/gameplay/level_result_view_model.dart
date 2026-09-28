import 'package:flutter/foundation.dart';

import '../../models/level_result.dart';
import 'level_result_calculator.dart';
import 'level_result_controller.dart';
import 'level_session.dart';

class LevelResultViewModel extends ChangeNotifier {
  LevelResultViewModel({
    LevelResultCalculator calculator =
        const LevelResultCalculator(),
    LevelResultController? controller,
  })  : _calculator = calculator,
        _controller =
            controller ?? LevelResultController() {
    _controller.addListener(_handleControllerChanged);
  }

  final LevelResultCalculator _calculator;
  final LevelResultController _controller;

  bool _disposed = false;

  LevelResultController get controller =>
      _controller;

  LevelResult? get result =>
      _controller.result;

  bool get hasResult =>
      _controller.hasResult;

  bool get isCompleted =>
      _controller.isCompleted;

  bool get isFailed =>
      _controller.isFailed;

  int get levelNumber =>
      _controller.levelNumber;

  int get score =>
      _controller.score;

  int get movesUsed =>
      _controller.movesUsed;

  int get movesRemaining =>
      _controller.movesRemaining;

  int get completedGoals =>
      _controller.completedGoals;

  int get totalGoals =>
      _controller.totalGoals;

  int get stars =>
      _controller.stars;

  double get goalProgress =>
      _controller.goalProgress;

  void calculate(LevelSession session) {
    _ensureActive();

    final calculatedResult =
        _calculator.calculate(session);

    _controller.setResult(
      calculatedResult,
    );
  }

  void setResult(LevelResult result) {
    _ensureActive();

    _controller.setResult(result);
  }

  void clear() {
    _ensureActive();

    _controller.clear();
  }

  void reset() {
    clear();
  }

  LevelResult requireResult() {
    _ensureActive();

    return _controller.requireResult();
  }

  void _handleControllerChanged() {
    if (_disposed) {
      return;
    }

    notifyListeners();
  }

  void _ensureActive() {
    if (_disposed) {
      throw StateError(
        'LevelResultViewModel has already been disposed.',
      );
    }
  }

  @override
  void dispose() {
    if (_disposed) {
      return;
    }

    _disposed = true;

    _controller.removeListener(
      _handleControllerChanged,
    );

    _controller.dispose();

    super.dispose();
  }
}
