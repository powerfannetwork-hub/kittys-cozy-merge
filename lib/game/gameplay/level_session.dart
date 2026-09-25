import '../../models/level_config.dart';
import '../../models/level_goal.dart';
import '../../services/level_repository.dart';
import '../board/game_board.dart';
import 'board_generator.dart';
import 'gem_swap.dart';
import 'level_goal_tracker.dart';
import 'move_result.dart';
import 'game_engine.dart';

class LevelSession {
  LevelSession._({
    required LevelConfig level,
    required GameBoard board,
    required LevelGoalTracker goalTracker,
    required GameEngine engine,
  })  : _level = level,
        _board = board,
        _goalTracker = goalTracker,
        _engine = engine;

  factory LevelSession.create({
    required int levelNumber,
    LevelRepository? levelRepository,
    BoardGenerator? boardGenerator,
  }) {
    final repository =
        levelRepository ?? LevelRepository.instance;

    final generator =
        boardGenerator ?? BoardGenerator();

    final level =
        repository.getLevel(levelNumber);

    final board = generator.generate(
      rows: level.rows,
      columns: level.columns,
    );

    final goalTracker =
        LevelGoalTracker(
      level: level,
    );

    final engine = GameEngine(
      board: board,
      moves: level.moves,
      goalTracker: goalTracker,
    );

    return LevelSession._(
      level: level,
      board: board,
      goalTracker: goalTracker,
      engine: engine,
    );
  }

  final LevelConfig _level;

  final GameBoard _board;

  final LevelGoalTracker _goalTracker;

  final GameEngine _engine;

  LevelConfig get level => _level;

  int get levelNumber =>
      _level.levelNumber;

  int get rows =>
      _level.rows;

  int get columns =>
      _level.columns;

  int get totalMoves =>
      _level.moves;

  GameBoard get board =>
      _board;

  LevelGoalTracker get goalTracker =>
      _goalTracker;

  GameEngine get engine =>
      _engine;

  List<LevelGoal> get goals =>
      _goalTracker.goals;

  int get movesRemaining =>
      _engine.movesRemaining;

  int get score =>
      _engine.score;

  bool get hasMovesRemaining =>
      _engine.hasMovesRemaining;

  bool get isComplete =>
      _goalTracker.isComplete;

  bool get isIncomplete =>
      _goalTracker.isIncomplete;

  double get goalProgress =>
      _goalTracker.overallProgress;

  MoveResult? makeMove(
    GemSwap swap,
  ) {
    if (isComplete) {
      return null;
    }

    if (!hasMovesRemaining) {
      return null;
    }

    return _engine.makeMove(swap);
  }

  LevelGoal goalAt(int index) {
    return _goalTracker.goalAt(index);
  }

  LevelGoal? goalForType(
    LevelGoalType type, {
    Object? gemType,
  }) {
    if (gemType == null) {
      return _goalTracker.goalForType(type);
    }

    throw ArgumentError(
      'gemType must use GemType when querying '
      'a collect-gem goal.',
    );
  }

  @override
  String toString() {
    return 'LevelSession('
        'level: $levelNumber, '
        'moves: $movesRemaining/$totalMoves, '
        'score: $score, '
        'goalProgress: $goalProgress, '
        'complete: $isComplete'
        ')';
  }
}
