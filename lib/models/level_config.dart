import 'level_goal.dart';

class LevelConfig {
  const LevelConfig({
    required this.levelNumber,
    required this.rows,
    required this.columns,
    required this.moves,
    required this.goals,
  });

  final int levelNumber;
  final int rows;
  final int columns;
  final int moves;
  final List<LevelGoal> goals;

  LevelConfig copyWith({
    int? levelNumber,
    int? rows,
    int? columns,
    int? moves,
    List<LevelGoal>? goals,
  }) {
    return LevelConfig(
      levelNumber: levelNumber ?? this.levelNumber,
      rows: rows ?? this.rows,
      columns: columns ?? this.columns,
      moves: moves ?? this.moves,
      goals: goals ?? this.goals,
    );
  }
}
