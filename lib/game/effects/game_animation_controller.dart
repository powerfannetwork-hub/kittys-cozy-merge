import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

enum GameAnimationType {
  swap,
  swapBack,
  gemMatch,
  gemCollect,
  gemFall,
  specialGem,
  bomb,
  rocket,
  colorBomb,
  invalidMove,
  goalComplete,
}

@immutable
class GameAnimationRequest {
  const GameAnimationRequest({
    required this.type,
    this.duration = const Duration(milliseconds: 220),
    this.delay = Duration.zero,
    this.intensity = 1.0,
  })  : assert(intensity >= 0.0);

  final GameAnimationType type;
  final Duration duration;
  final Duration delay;
  final double intensity;

  GameAnimationRequest copyWith({
    GameAnimationType? type,
    Duration? duration,
    Duration? delay,
    double? intensity,
  }) {
    return GameAnimationRequest(
      type: type ?? this.type,
      duration: duration ?? this.duration,
      delay: delay ?? this.delay,
      intensity: intensity ?? this.intensity,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GameAnimationRequest &&
        other.type == type &&
        other.duration == duration &&
        other.delay == delay &&
        other.intensity == intensity;
  }

  @override
  int get hashCode {
    return Object.hash(
      type,
      duration,
      delay,
      intensity,
    );
  }
}

class GameAnimationController extends ChangeNotifier {
  GameAnimationController({
    Duration defaultDuration = const Duration(
      milliseconds: 220,
    ),
  }) : _defaultDuration = defaultDuration;

  final Duration _defaultDuration;

  GameAnimationRequest? _currentRequest;

  double _progress = 0.0;

  bool _running = false;

  DateTime? _startedAt;

  GameAnimationRequest? get currentRequest =>
      _currentRequest;

  double get progress => _progress;

  bool get isRunning => _running;

  bool get isIdle => !_running;

  Duration get defaultDuration => _defaultDuration;

  void start(
    GameAnimationType type, {
    Duration? duration,
    Duration delay = Duration.zero,
    double intensity = 1.0,
  }) {
    _currentRequest = GameAnimationRequest(
      type: type,
      duration: duration ?? _defaultDuration,
      delay: delay,
      intensity: intensity,
    );

    _progress = 0.0;
    _running = true;
    _startedAt = DateTime.now();

    notifyListeners();
  }

  void updateProgress(
    double value,
  ) {
    if (!_running) {
      return;
    }

    final clampedValue = value.clamp(
      0.0,
      1.0,
    );

    _progress = clampedValue.toDouble();

    notifyListeners();
  }

  void complete() {
    if (!_running) {
      return;
    }

    _progress = 1.0;
    _running = false;

    notifyListeners();
  }

  void cancel() {
    if (!_running && _currentRequest == null) {
      return;
    }

    _running = false;
    _progress = 0.0;
    _startedAt = null;

    notifyListeners();
  }

  void reset() {
    _currentRequest = null;
    _progress = 0.0;
    _running = false;
    _startedAt = null;

    notifyListeners();
  }

  Duration get elapsed {
    final startedAt = _startedAt;

    if (startedAt == null) {
      return Duration.zero;
    }

    return DateTime.now().difference(
      startedAt,
    );
  }

  double get normalizedElapsed {
    final request = _currentRequest;

    if (request == null ||
        request.duration <= Duration.zero) {
      return _progress;
    }

    final elapsedMilliseconds =
        elapsed.inMilliseconds;

    final durationMilliseconds =
        request.duration.inMilliseconds;

    if (durationMilliseconds <= 0) {
      return _progress;
    }

    final value =
        elapsedMilliseconds / durationMilliseconds;

    if (value <= 0.0) {
      return 0.0;
    }

    if (value >= 1.0) {
      return 1.0;
    }

    return value;
  }

  bool isType(
    GameAnimationType type,
  ) {
    return _currentRequest?.type == type;
  }

  @override
  void dispose() {
    _currentRequest = null;
    _running = false;
    _startedAt = null;

    super.dispose();
  }
}
