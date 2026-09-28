import 'package:flutter/foundation.dart';

import '../../models/level_result.dart';

class LevelResultController extends ChangeNotifier {
  LevelResultController();

  LevelResult? _result;
  bool _disposed = false;

  LevelResult? get result => _result;

  bool get hasResult => _result != null;

  bool get isCompleted =>
      _result?.isCompleted ?? false;

  bool get isFailed =>
      _result?.isFailed ?? false;

  int get levelNumber =>
      _result?.levelNumber ?? 0;

  int get score =>
      _result?.score ?? 0;

  int get movesUsed =>
      _result?.movesUsed ?? 0;

  int get movesRemaining =>
      _result?.movesRemaining ?? 0;

  int get completedGoals =>
      _result?.completedGoals ?? 0;

  int get totalGoals =>
      _result?.totalGoals ?? 0;

  int get stars =>
      _result?.stars ?? 0;

  double get goalProgress =>
      _result?.goalProgress ?? 0.0;

  void setResult(LevelResult result) {
    _ensureActive();

    if (_result == result) {
      return;
    }

    _result = result;

    notifyListeners();
  }

  void clear() {
    _ensureActive();

    if (_result == null) {
      return;
    }

    _result = null;

    notifyListeners();
  }

  void reset() {
    clear();
  }

  LevelResult requireResult() {
    _ensureActive();

    final currentResult = _result;

    if (currentResult == null) {
      throw StateError(
        'No level result is currently available.',
      );
    }

    return currentResult;
  }

  @override
  void dispose() {
    if (_disposed) {
      return;
    }

    _disposed = true;
    _result = null;

    super.dispose();
  }

  void _ensureActive() {
    if (_disposed) {
      throw StateError(
        'LevelResultController has already been disposed.',
      );
    }
  }
}
