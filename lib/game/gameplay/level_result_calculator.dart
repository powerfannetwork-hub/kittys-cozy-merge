import '../../models/level_result.dart';
import 'level_session.dart';

class LevelResultCalculator {
  const LevelResultCalculator();

  LevelResult calculate(
    LevelSession session,
  ) {
    final completedGoals =
        session.goalTracker.completedGoalCount;

    final totalGoals =
        session.goalTracker.goalCount;

    final isCompleted =
        session.isComplete;

    final movesRemaining =
        session.movesRemaining;

    final movesUsed =
        _calculateMovesUsed(
      totalMoves: session.totalMoves,
      movesRemaining: movesRemaining,
    );

    final stars = isCompleted
        ? calculateStars(
            totalMoves: session.totalMoves,
            movesRemaining: movesRemaining,
          )
        : 0;

    return LevelResult(
      levelNumber: session.levelNumber,
      type: isCompleted
          ? LevelResultType.completed
          : LevelResultType.failed,
      score: session.score,
      movesUsed: movesUsed,
      movesRemaining: movesRemaining,
      completedGoals: completedGoals,
      totalGoals: totalGoals,
      stars: stars,
    );
  }

  int calculateStars({
    required int totalMoves,
    required int movesRemaining,
  }) {
    if (totalMoves <= 0 ||
        movesRemaining <= 0) {
      return 1;
    }

    final safeRemaining =
        movesRemaining > totalMoves
            ? totalMoves
            : movesRemaining;

    final remainingRatio =
        safeRemaining / totalMoves;

    if (remainingRatio >= 0.50) {
      return 3;
    }

    if (remainingRatio >= 0.25) {
      return 2;
    }

    return 1;
  }

  int _calculateMovesUsed({
    required int totalMoves,
    required int movesRemaining,
  }) {
    final used =
        totalMoves - movesRemaining;

    if (used <= 0) {
      return 0;
    }

    return used;
  }
}
