import 'dart:math' as math;

enum LevelDifficultyTier {
beginner,
easy,
medium,
hard,
advanced,
expert,
master,
elite,
endgame,
finalChallenge,
}

enum LevelSpecialType {
normal,
treasure,
targetRush,
powerSurge,
diamondHunt,
comboChallenge,
iceFortress,
lockedKingdom,
rainbowChallenge,
elite,
bonus,
}

class LevelDifficultyProfile {
const LevelDifficultyProfile({
required this.levelNumber,
required this.tier,
required this.specialType,
required this.moves,
required this.minimumMoves,
required this.maximumMoves,
required this.maxIceLayers,
required this.iceDensity,
required this.blockDensity,
required this.lockedTileDensity,
required this.usesBlocks,
required this.usesLockedTiles,
required this.usesMultiLayerIce,
required this.maxGoals,
required this.allowSpecialGemChallenge,
required this.isMilestoneLevel,
});

final int levelNumber;
final LevelDifficultyTier tier;
final LevelSpecialType specialType;

final int moves;
final int minimumMoves;
final int maximumMoves;

final int maxIceLayers;

final double iceDensity;
final double blockDensity;
final double lockedTileDensity;

final bool usesBlocks;
final bool usesLockedTiles;
final bool usesMultiLayerIce;

final int maxGoals;

final bool allowSpecialGemChallenge;
final bool isMilestoneLevel;

bool get hasObstacles =>
usesBlocks ||
usesLockedTiles ||
maxIceLayers > 0;

bool get isSpecialLevel =>
specialType != LevelSpecialType.normal;

bool get isHighDifficulty =>
tier.index >= LevelDifficultyTier.expert.index;

@override
String toString() {
return 'LevelDifficultyProfile('
'levelNumber: $levelNumber, '
'tier: $tier, '
'specialType: $specialType, '
'moves: $moves, '
'maxIceLayers: $maxIceLayers, '
'iceDensity: $iceDensity, '
'blockDensity: $blockDensity, '
'lockedTileDensity: $lockedTileDensity, '
'maxGoals: $maxGoals, '
'allowSpecialGemChallenge: $allowSpecialGemChallenge, '
'isMilestoneLevel: $isMilestoneLevel'
')';
}
}

class LevelDifficultySystem {
LevelDifficultySystem._();

static const int minimumLevel = 1;
static const int maximumLevel = 5000;

static LevelDifficultyProfile profileFor(
int levelNumber,
) {
final level = _normalizeLevel(levelNumber);
final tier = _tierFor(level);
final specialType = _specialTypeFor(level);

final movesRange = _movesRangeFor(
  level,
  tier,
  specialType,
);

final moves = _movesFor(
  level,
  minimum: movesRange.$1,
  maximum: movesRange.$2,
);

final maxIceLayers = _maxIceLayersFor(level);
final iceDensity = _iceDensityFor(level);
final blockDensity = _blockDensityFor(level);
final lockedTileDensity =
    _lockedTileDensityFor(level);

final usesBlocks = blockDensity > 0;
final usesLockedTiles =
    lockedTileDensity > 0;

final usesMultiLayerIce =
    maxIceLayers >= 2;

final maxGoals = _maxGoalsFor(
  level,
  specialType,
);

return LevelDifficultyProfile(
  levelNumber: level,
  tier: tier,
  specialType: specialType,
  moves: moves,
  minimumMoves: movesRange.$1,
  maximumMoves: movesRange.$2,
  maxIceLayers: maxIceLayers,
  iceDensity: iceDensity,
  blockDensity: blockDensity,
  lockedTileDensity: lockedTileDensity,
  usesBlocks: usesBlocks,
  usesLockedTiles: usesLockedTiles,
  usesMultiLayerIce: usesMultiLayerIce,
  maxGoals: maxGoals,
  allowSpecialGemChallenge:
      level >= 501,
  isMilestoneLevel:
      _isMilestoneLevel(level),
);

}

static LevelDifficultyTier _tierFor(
int level,
) {
if (level <= 50) {
return LevelDifficultyTier.beginner;
}

if (level <= 100) {
  return LevelDifficultyTier.easy;
}

if (level <= 250) {
  return LevelDifficultyTier.medium;
}

if (level <= 500) {
  return LevelDifficultyTier.hard;
}

if (level <= 1000) {
  return LevelDifficultyTier.advanced;
}

if (level <= 1500) {
  return LevelDifficultyTier.expert;
}

if (level <= 2500) {
  return LevelDifficultyTier.master;
}

if (level <= 3500) {
  return LevelDifficultyTier.elite;
}

if (level <= 4999) {
  return LevelDifficultyTier.endgame;
}

return LevelDifficultyTier.finalChallenge;

}

static LevelSpecialType _specialTypeFor(
int level,
) {
if (level == 5000) {
return LevelSpecialType.elite;
}

if (level % 500 == 0) {
  return LevelSpecialType.bonus;
}

if (level % 250 == 0) {
  return LevelSpecialType.treasure;
}

if (level % 100 == 0) {
  return LevelSpecialType.powerSurge;
}

if (level >= 3501 &&
    level % 37 == 0) {
  return LevelSpecialType.elite;
}

if (level >= 2501 &&
    level % 31 == 0) {
  return LevelSpecialType.rainbowChallenge;
}

if (level >= 1501 &&
    level % 29 == 0) {
  return LevelSpecialType.lockedKingdom;
}

if (level >= 1001 &&
    level % 23 == 0) {
  return LevelSpecialType.iceFortress;
}

if (level >= 501 &&
    level % 19 == 0) {
  return LevelSpecialType.comboChallenge;
}

if (level >= 251 &&
    level % 17 == 0) {
  return LevelSpecialType.targetRush;
}

if (level >= 101 &&
    level % 13 == 0) {
  return LevelSpecialType.diamondHunt;
}

return LevelSpecialType.normal;

}

static (int, int) _movesRangeFor(
int level,
LevelDifficultyTier tier,
LevelSpecialType specialType,
) {
int minimum;
int maximum;

switch (tier) {
  case LevelDifficultyTier.beginner:
    minimum = 18;
    maximum = 32;
    break;

  case LevelDifficultyTier.easy:
    minimum = 18;
    maximum = 30;
    break;

  case LevelDifficultyTier.medium:
    minimum = 17;
    maximum = 28;
    break;

  case LevelDifficultyTier.hard:
    minimum = 16;
    maximum = 27;
    break;

  case LevelDifficultyTier.advanced:
    minimum = 15;
    maximum = 26;
    break;

  case LevelDifficultyTier.expert:
    minimum = 14;
    maximum = 25;
    break;

  case LevelDifficultyTier.master:
    minimum = 13;
    maximum = 24;
    break;

  case LevelDifficultyTier.elite:
    minimum = 12;
    maximum = 23;
    break;

  case LevelDifficultyTier.endgame:
    minimum = 11;
    maximum = 22;
    break;

  case LevelDifficultyTier.finalChallenge:
    minimum = 20;
    maximum = 20;
    break;
}

if (specialType == LevelSpecialType.bonus ||
    specialType == LevelSpecialType.treasure) {
  minimum += 2;
  maximum += 2;
}

if (specialType == LevelSpecialType.elite) {
  minimum = math.max(10, minimum - 2);
  maximum = math.max(
    minimum,
    maximum - 2,
  );
}

return (minimum, maximum);

}

static int _movesFor(
int level, {
required int minimum,
required int maximum,
}) {
if (minimum >= maximum) {
return minimum;
}

final span = maximum - minimum;

final wave =
    ((level * 37) + (level ~/ 7)) % (span + 1);

return minimum + wave;

}

static int _maxIceLayersFor(
int level,
) {
if (level < 101) {
return level >= 51 ? 1 : 0;
}

if (level < 501) {
  return 1;
}

if (level < 1501) {
  return 2;
}

if (level < 3001) {
  return 3;
}

return 4;

}

static double _iceDensityFor(
int level,
) {
if (level < 51) {
return 0.0;
}

if (level < 101) {
  return 0.10;
}

if (level < 251) {
  return 0.16;
}

if (level < 501) {
  return 0.22;
}

if (level < 1001) {
  return 0.28;
}

if (level < 1501) {
  return 0.34;
}

if (level < 2501) {
  return 0.40;
}

if (level < 3501) {
  return 0.46;
}

return 0.52;

}

static double _blockDensityFor(
int level,
) {
if (level < 51) {
return 0.0;
}

if (level < 101) {
  return 0.06;
}

if (level < 251) {
  return 0.10;
}

if (level < 501) {
  return 0.14;
}

if (level < 1001) {
  return 0.18;
}

if (level < 1501) {
  return 0.22;
}

if (level < 2501) {
  return 0.26;
}

if (level < 3501) {
  return 0.30;
}

return 0.34;

}

static double _lockedTileDensityFor(
int level,
) {
if (level < 101) {
return 0.0;
}

if (level < 251) {
  return 0.04;
}

if (level < 501) {
  return 0.08;
}

if (level < 1001) {
  return 0.12;
}

if (level < 1501) {
  return 0.16;
}

if (level < 2501) {
  return 0.20;
}

if (level < 3501) {
  return 0.24;
}

return 0.28;

}

static int _maxGoalsFor(
int level,
LevelSpecialType specialType,
) {
int goals;

if (level <= 50) {
  goals = 2;
} else if (level <= 250) {
  goals = 3;
} else if (level <= 1000) {
  goals = 4;
} else if (level <= 2500) {
  goals = 4;
} else {
  goals = 5;
}

if (specialType == LevelSpecialType.elite ||
    specialType ==
        LevelSpecialType.rainbowChallenge) {
  goals += 1;
}

return math.min(goals, 5);

}

static bool _isMilestoneLevel(
int level,
) {
return level == 50 ||
level == 100 ||
level == 250 ||
level == 500 ||
level == 1000 ||
level == 1500 ||
level == 2500 ||
level == 3500 ||
level == 4500 ||
level == 5000;
}

static int _normalizeLevel(
int level,
) {
if (level < minimumLevel) {
return minimumLevel;
}

if (level > maximumLevel) {
  return maximumLevel;
}

return level;

}
}
