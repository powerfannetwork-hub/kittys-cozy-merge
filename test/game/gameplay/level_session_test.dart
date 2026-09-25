import 'package:flutter_test/flutter_test.dart';

import '../../../lib/game/board/board_position.dart';
import '../../../lib/game/board/game_board.dart';
import '../../../lib/game/gameplay/game_engine.dart';
import '../../../lib/game/gameplay/gem_swap.dart';
import '../../../lib/game/gameplay/level_goal_tracker.dart';
import '../../../lib/game/gameplay/level_session.dart';
import '../../../lib/game/gameplay/match_detector.dart';
import '../../../lib/game/gameplay/board_generator.dart';
import '../../../lib/game/gameplay/swap_result.dart';
import '../../../lib/models/gem_type.dart';
import '../../../lib/models/level_config.dart';
import '../../../lib/models/level_goal.dart';
import '../../../lib/services/level_repository.dart';
import '../../../lib/game/gems/gem.dart';

void main() {
  group('LevelRepository', () {
    test(
      'contains the first ten levels',
      () {
        final repository =
            LevelRepository.instance;

        expect(repository.levelCount, 10);
        expect(repository.hasLevel(1), isTrue);
        expect(repository.hasLevel(10), isTrue);
        expect(repository.hasLevel(11), isFalse);
      },
    );

    test(
      'returns a fresh level configuration with zero goal progress',
      () {
        final repository =
            LevelRepository.instance;

        final level =
            repository.getLevel(1);

        expect(level.levelNumber, 1);
        expect(level.rows, 8);
        expect(level.columns, 8);
        expect(level.moves, 20);
        expect(level.goals, isNotEmpty);

        for (final goal in level.goals) {
          expect(goal.current, 0);
        }
      },
    );

    test(
      'returns the next level correctly',
      () {
        final repository =
            LevelRepository.instance;

        final nextLevel =
            repository.getNextLevel(1);

        expect(
          nextLevel?.levelNumber,
          2,
        );
      },
    );
  });

  group('BoardGenerator', () {
    test(
      'creates an 8 by 8 board without an initial match',
      () {
        final generator =
            BoardGenerator();

        final board =
            generator.generate(
          rows: 8,
          columns: 8,
        );

        expect(board.rows, 8);
        expect(board.columns, 8);

        final matches =
            const MatchDetector()
                .findMatches(board);

        expect(
          matches.hasMatch,
          isFalse,
        );

        for (int row = 0;
            row < board.rows;
            row++) {
          for (int column = 0;
              column < board.columns;
              column++) {
            final position =
                BoardPosition(
              row: row,
              column: column,
            );

            expect(
              board.gemAt(position),
              isNotNull,
            );
          }
        }
      },
    );
  });

  group('LevelGoalTracker', () {
    late LevelConfig level;
    late LevelGoalTracker tracker;

    setUp(() {
      level = const LevelConfig(
        levelNumber: 1,
        rows: 8,
        columns: 8,
        moves: 20,
        goals: <LevelGoal>[
          LevelGoal(
            type: LevelGoalType.collectGem,
            target: 3,
            gemType: GemType.pink,
          ),
          LevelGoal(
            type: LevelGoalType.reachScore,
            target: 100,
          ),
        ],
      );

      tracker = LevelGoalTracker(
        level: level,
      );
    });

    test(
      'starts with zero progress',
      () {
        expect(
          tracker.completedGoalCount,
          0,
        );

        expect(
          tracker.isComplete,
          isFalse,
        );

        expect(
          tracker.overallProgress,
          0.0,
        );
      },
    );

    test(
      'tracks collected gems',
      () {
        tracker.collectGems(
          gemType: GemType.pink,
          amount: 2,
        );

        final goal =
            tracker.goalForType(
          LevelGoalType.collectGem,
          gemType: GemType.pink,
        );

        expect(
          goal?.current,
          2,
        );

        expect(
          tracker.isComplete,
          isFalse,
        );

        tracker.collectGems(
          gemType: GemType.pink,
          amount: 1,
        );

        expect(
          tracker.goalForType(
            LevelGoalType.collectGem,
            gemType: GemType.pink,
          )?.current,
          3,
        );
      },
    );

    test(
      'tracks score progress',
      () {
        tracker.addScore(40);

        expect(
          tracker.goalForType(
            LevelGoalType.reachScore,
          )?.current,
          40,
        );

        tracker.addScore(60);

        expect(
          tracker.goalForType(
            LevelGoalType.reachScore,
          )?.current,
          100,
        );

        expect(
          tracker.goalForType(
            LevelGoalType.reachScore,
          )?.isComplete,
          isTrue,
        );
      },
    );

    test(
      'does not allow progress above a goal target',
      () {
        tracker.collectGems(
          gemType: GemType.pink,
          amount: 100,
        );

        expect(
          tracker.goalForType(
            LevelGoalType.collectGem,
            gemType: GemType.pink,
          )?.current,
          3,
        );
      },
    );

    test(
      'reset returns all goals to zero',
      () {
        tracker.collectGems(
          gemType: GemType.pink,
          amount: 3,
        );

        tracker.addScore(100);

        expect(
          tracker.isComplete,
          isTrue,
        );

        tracker.reset();

        expect(
          tracker.isComplete,
          isFalse,
        );

        expect(
          tracker.goalForType(
            LevelGoalType.collectGem,
            gemType: GemType.pink,
          )?.current,
          0,
        );

        expect(
          tracker.goalForType(
            LevelGoalType.reachScore,
          )?.current,
          0,
        );
      },
    );
  });

  group('GameEngine', () {
    test(
      'invalid swap does not consume a move',
      () {
        final board =
            _createTestBoard();

        final engine = GameEngine(
          board: board,
          moves: 5,
        );

        final result =
            engine.trySwap(
          const GemSwap(
            from: BoardPosition(
              row: 0,
              column: 0,
            ),
            to: BoardPosition(
              row: 0,
              column: 2,
            ),
          ),
        );

        expect(
          result.status,
          SwapStatus.invalid,
        );

        expect(
          engine.movesRemaining,
          5,
        );
      },
    );

    test(
      'swap with no match is reverted and does not consume a move',
      () {
        final board =
            _createNoMatchBoard();

        final engine = GameEngine(
          board: board,
          moves: 5,
        );

        final beforeFirst =
            board.gemAt(
          const BoardPosition(
            row: 0,
            column: 0,
          ),
        );

        final beforeSecond =
            board.gemAt(
          const BoardPosition(
            row: 0,
            column: 1,
          ),
        );

        final result =
            engine.trySwap(
          const GemSwap(
            from: BoardPosition(
              row: 0,
              column: 0,
            ),
            to: BoardPosition(
              row: 0,
              column: 1,
            ),
          ),
        );

        expect(
          result.status,
          SwapStatus.noMatch,
        );

        expect(
          engine.movesRemaining,
          5,
        );

        expect(
          board.gemAt(
            const BoardPosition(
              row: 0,
              column: 0,
            ),
          ),
          beforeFirst,
        );

        expect(
          board.gemAt(
            const BoardPosition(
              row: 0,
              column: 1,
            ),
          ),
          beforeSecond,
        );
      },
    );

    test(
      'successful match consumes one move',
      () {
        final board =
            _createMatchBoard();

        final engine = GameEngine(
          board: board,
          moves: 5,
        );

        final result =
            engine.trySwap(
          const GemSwap(
            from: BoardPosition(
              row: 0,
              column: 1,
            ),
            to: BoardPosition(
              row: 1,
              column: 1,
            ),
          ),
        );

        expect(
          result.status,
          SwapStatus.successful,
        );

        expect(
          engine.movesRemaining,
          4,
        );

        expect(
          result.matchedPositions,
          isNotEmpty,
        );

        expect(
          result.scoreGained,
          greaterThan(0),
        );

        expect(
          engine.score,
          greaterThan(0),
        );
      },
    );
  });

  group('LevelSession', () {
    test(
      'creates Level 1 with its configured board and moves',
      () {
        final session =
            LevelSession.create(
          levelNumber: 1,
        );

        expect(
          session.levelNumber,
          1,
        );

        expect(
          session.rows,
          8,
        );

        expect(
          session.columns,
          8,
        );

        expect(
          session.totalMoves,
          20,
        );

        expect(
          session.movesRemaining,
          20,
        );

        expect(
          session.score,
          0,
        );

        expect(
          session.goals,
          isNotEmpty,
        );

        expect(
          session.isComplete,
          isFalse,
        );
      },
    );

    test(
      'session goal tracker and engine use the same level',
      () {
        final session =
            LevelSession.create(
          levelNumber: 1,
        );

        expect(
          session.goalTracker.level.levelNumber,
          session.levelNumber,
        );

        expect(
          session.engine.goalTracker,
          same(session.goalTracker),
        );
      },
    );

    test(
      'session exposes the configured goal progress',
      () {
        final session =
            LevelSession.create(
          levelNumber: 1,
        );

        expect(
          session.goalProgress,
          0.0,
        );

        expect(
          session.goalTracker.goals,
          isNotEmpty,
        );
      },
    );
  });
}

GameBoard _createNoMatchBoard() {
  final board =
      GameBoard(
    rows: 3,
    columns: 3,
  );

  const types =
      <List<GemType>>[
    <GemType>[
      GemType.pink,
      GemType.blue,
      GemType.green,
    ],
    <GemType>[
      GemType.yellow,
      GemType.pink,
      GemType.blue,
    ],
    <GemType>[
      GemType.green,
      GemType.yellow,
      GemType.pink,
    ],
  ];

  _fillBoard(
    board,
    types,
  );

  return board;
}

GameBoard _createMatchBoard() {
  final board =
      GameBoard(
    rows: 3,
    columns: 3,
  );

  const types =
      <List<GemType>>[
    <GemType>[
      GemType.pink,
      GemType.blue,
      GemType.pink,
    ],
    <GemType>[
      GemType.blue,
      GemType.pink,
      GemType.green,
    ],
    <GemType>[
      GemType.yellow,
      GemType.blue,
      GemType.green,
    ],
  ];

  _fillBoard(
    board,
    types,
  );

  return board;
}

GameBoard _createTestBoard() {
  final board =
      GameBoard(
    rows: 3,
    columns: 3,
  );

  const types =
      <List<GemType>>[
    <GemType>[
      GemType.pink,
      GemType.blue,
      GemType.green,
    ],
    <GemType>[
      GemType.yellow,
      GemType.pink,
      GemType.blue,
    ],
    <GemType>[
      GemType.green,
      GemType.yellow,
      GemType.orange,
    ],
  ];

  _fillBoard(
    board,
    types,
  );

  return board;
}

void _fillBoard(
  GameBoard board,
  List<List<GemType>> types,
) {
  for (int row = 0;
      row < board.rows;
      row++) {
    for (int column = 0;
        column < board.columns;
        column++) {
      final position =
          BoardPosition(
        row: row,
        column: column,
      );

      board.setGem(
        position,
        Gem(
          id: 'test_${row}_$column',
          type: types[row][column],
          position: position,
        ),
      );
    }
  }
}
