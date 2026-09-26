import 'package:flutter/foundation.dart';

import '../board/board_position.dart';
import '../gems/gem.dart';

enum MoveEffectType {
  swapStarted,
  swapCompleted,
  swapRejected,
  matchStarted,
  matchCompleted,
  gemRemoved,
  gemCollected,
  gemFalling,
  specialGemCreated,
  specialGemActivated,
  cascadeStarted,
  cascadeCompleted,
  goalProgress,
  goalCompleted,
}

@immutable
class MoveEffect {
  const MoveEffect({
    required this.type,
    this.position,
    this.positions = const <BoardPosition>[],
    this.gem,
    this.gems = const <Gem>[],
    this.score = 0,
    this.count = 0,
    this.chain = 0,
    this.delay = Duration.zero,
    this.duration = const Duration(
      milliseconds: 220,
    ),
  });

  final MoveEffectType type;

  final BoardPosition? position;

  final List<BoardPosition> positions;

  final Gem? gem;

  final List<Gem> gems;

  final int score;

  final int count;

  final int chain;

  final Duration delay;

  final Duration duration;

  bool get hasPosition => position != null;

  bool get hasPositions => positions.isNotEmpty;

  bool get hasGem => gem != null;

  bool get hasGems => gems.isNotEmpty;

  MoveEffect copyWith({
    MoveEffectType? type,
    BoardPosition? position,
    List<BoardPosition>? positions,
    Gem? gem,
    List<Gem>? gems,
    int? score,
    int? count,
    int? chain,
    Duration? delay,
    Duration? duration,
  }) {
    return MoveEffect(
      type: type ?? this.type,
      position: position ?? this.position,
      positions: positions ?? this.positions,
      gem: gem ?? this.gem,
      gems: gems ?? this.gems,
      score: score ?? this.score,
      count: count ?? this.count,
      chain: chain ?? this.chain,
      delay: delay ?? this.delay,
      duration: duration ?? this.duration,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MoveEffect &&
        other.type == type &&
        other.position == position &&
        listEquals(
          other.positions,
          positions,
        ) &&
        other.gem == gem &&
        listEquals(
          other.gems,
          gems,
        ) &&
        other.score == score &&
        other.count == count &&
        other.chain == chain &&
        other.delay == delay &&
        other.duration == duration;
  }

  @override
  int get hashCode {
    return Object.hash(
      type,
      position,
      Object.hashAll(positions),
      gem,
      Object.hashAll(gems),
      score,
      count,
      chain,
      delay,
      duration,
    );
  }
}

class MoveEffects extends ChangeNotifier {
  MoveEffects({
    Duration defaultDuration = const Duration(
      milliseconds: 220,
    ),
  }) : _defaultDuration = defaultDuration;

  final Duration _defaultDuration;

  final List<MoveEffect> _effects =
      <MoveEffect>[];

  bool _playing = false;

  int _currentIndex = -1;

  MoveEffect? get current {
    if (_currentIndex < 0 ||
        _currentIndex >= _effects.length) {
      return null;
    }

    return _effects[_currentIndex];
  }

  List<MoveEffect> get effects =>
      List<MoveEffect>.unmodifiable(_effects);

  bool get isPlaying => _playing;

  bool get isEmpty => _effects.isEmpty;

  bool get isComplete =>
      _effects.isNotEmpty &&
      !_playing &&
      _currentIndex >= _effects.length;

  int get currentIndex => _currentIndex;

  int get length => _effects.length;

  Duration get defaultDuration =>
      _defaultDuration;

  void add(
    MoveEffect effect,
  ) {
    _effects.add(effect);

    notifyListeners();
  }

  void addAll(
    Iterable<MoveEffect> effects,
  ) {
    _effects.addAll(effects);

    notifyListeners();
  }

  void clear() {
    _effects.clear();
    _currentIndex = -1;
    _playing = false;

    notifyListeners();
  }

  void reset() {
    _currentIndex = -1;
    _playing = false;

    notifyListeners();
  }

  void start() {
    if (_effects.isEmpty) {
      _playing = false;
      _currentIndex = -1;

      notifyListeners();
      return;
    }

    _currentIndex = 0;
    _playing = true;

    notifyListeners();
  }

  MoveEffect? next() {
    if (_effects.isEmpty) {
      _playing = false;
      _currentIndex = -1;

      notifyListeners();
      return null;
    }

    if (_currentIndex < 0) {
      _currentIndex = 0;
      _playing = true;

      notifyListeners();

      return current;
    }

    final nextIndex =
        _currentIndex + 1;

    if (nextIndex >= _effects.length) {
      _currentIndex = _effects.length;
      _playing = false;

      notifyListeners();

      return null;
    }

    _currentIndex = nextIndex;
    _playing = true;

    notifyListeners();

    return current;
  }

  void finishCurrent() {
    if (!_playing) {
      return;
    }

    next();
  }

  void stop() {
    _playing = false;

    notifyListeners();
  }

  MoveEffect addSwapStarted({
    required BoardPosition from,
    required BoardPosition to,
  }) {
    final effect = MoveEffect(
      type: MoveEffectType.swapStarted,
      positions: <BoardPosition>[
        from,
        to,
      ],
      duration: _defaultDuration,
    );

    add(effect);

    return effect;
  }

  MoveEffect addSwapCompleted({
    required BoardPosition from,
    required BoardPosition to,
  }) {
    final effect = MoveEffect(
      type: MoveEffectType.swapCompleted,
      positions: <BoardPosition>[
        from,
        to,
      ],
      duration: _defaultDuration,
    );

    add(effect);

    return effect;
  }

  MoveEffect addSwapRejected({
    required BoardPosition from,
    required BoardPosition to,
  }) {
    final effect = MoveEffect(
      type: MoveEffectType.swapRejected,
      positions: <BoardPosition>[
        from,
        to,
      ],
      duration: const Duration(
        milliseconds: 180,
      ),
    );

    add(effect);

    return effect;
  }

  MoveEffect addMatchStarted({
    required List<BoardPosition> positions,
    int chain = 0,
  }) {
    final effect = MoveEffect(
      type: MoveEffectType.matchStarted,
      positions: List<BoardPosition>.from(
        positions,
      ),
      count: positions.length,
      chain: chain,
      duration: _defaultDuration,
    );

    add(effect);

    return effect;
  }

  MoveEffect addMatchCompleted({
    required List<BoardPosition> positions,
    int score = 0,
    int chain = 0,
  }) {
    final effect = MoveEffect(
      type: MoveEffectType.matchCompleted,
      positions: List<BoardPosition>.from(
        positions,
      ),
      score: score,
      count: positions.length,
      chain: chain,
      duration: _defaultDuration,
    );

    add(effect);

    return effect;
  }

  MoveEffect addGemRemoved({
    required BoardPosition position,
    Gem? gem,
    int score = 0,
  }) {
    final effect = MoveEffect(
      type: MoveEffectType.gemRemoved,
      position: position,
      gem: gem,
      score: score,
      duration: const Duration(
        milliseconds: 180,
      ),
    );

    add(effect);

    return effect;
  }

  MoveEffect addGemCollected({
    required BoardPosition position,
    Gem? gem,
    int score = 0,
  }) {
    final effect = MoveEffect(
      type: MoveEffectType.gemCollected,
      position: position,
      gem: gem,
      score: score,
      duration: const Duration(
        milliseconds: 220,
      ),
    );

    add(effect);

    return effect;
  }

  MoveEffect addGemFalling({
    required BoardPosition position,
    Gem? gem,
    Duration? delay,
  }) {
    final effect = MoveEffect(
      type: MoveEffectType.gemFalling,
      position: position,
      gem: gem,
      delay: delay ?? Duration.zero,
      duration: const Duration(
        milliseconds: 260,
      ),
    );

    add(effect);

    return effect;
  }

  MoveEffect addSpecialGemCreated({
    required BoardPosition position,
    required Gem gem,
  }) {
    final effect = MoveEffect(
      type: MoveEffectType.specialGemCreated,
      position: position,
      gem: gem,
      duration: const Duration(
        milliseconds: 300,
      ),
    );

    add(effect);

    return effect;
  }

  MoveEffect addSpecialGemActivated({
    required BoardPosition position,
    required Gem gem,
    List<BoardPosition> affectedPositions =
        const <BoardPosition>[],
  }) {
    final effect = MoveEffect(
      type: MoveEffectType.specialGemActivated,
      position: position,
      positions:
          List<BoardPosition>.from(
        affectedPositions,
      ),
      gem: gem,
      count: affectedPositions.length,
      duration: const Duration(
        milliseconds: 320,
      ),
    );

    add(effect);

    return effect;
  }

  MoveEffect addCascadeStarted({
    int chain = 0,
  }) {
    final effect = MoveEffect(
      type: MoveEffectType.cascadeStarted,
      chain: chain,
      duration: _defaultDuration,
    );

    add(effect);

    return effect;
  }

  MoveEffect addCascadeCompleted({
    int chain = 0,
    int score = 0,
  }) {
    final effect = MoveEffect(
      type: MoveEffectType.cascadeCompleted,
      chain: chain,
      score: score,
      duration: _defaultDuration,
    );

    add(effect);

    return effect;
  }

  MoveEffect addGoalProgress({
    required int count,
    int score = 0,
  }) {
    final effect = MoveEffect(
      type: MoveEffectType.goalProgress,
      count: count,
      score: score,
      duration: const Duration(
        milliseconds: 180,
      ),
    );

    add(effect);

    return effect;
  }

  MoveEffect addGoalCompleted({
    int score = 0,
  }) {
    final effect = MoveEffect(
      type: MoveEffectType.goalCompleted,
      score: score,
      duration: const Duration(
        milliseconds: 320,
      ),
    );

    add(effect);

    return effect;
  }

  @override
  void dispose() {
    _effects.clear();
    _currentIndex = -1;
    _playing = false;

    super.dispose();
  }
}
