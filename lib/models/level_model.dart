enum ObstacleType {
  none,
  frozenCrystal,
  shadowStone,
  energyLock,
  windBarrier,
  lavaCrystal,
  natureRoots,
  portalTile,
  moonCrystal,
  ancientMachine,
  stormCloud,
  mutationGem,
  waterFlow,
  titanBlock,
  cosmicRift,
  kingdomBoss,
}

class LevelModel {
  final int level;

  final int moves;

  final int targetScore;

  final int rewardCoins;

  final int rewardGems;

  final int starsRequired1;

  final int starsRequired2;

  final int starsRequired3;

  final ObstacleType obstacleType;

  final int obstacleStrength;

  const LevelModel({
    required this.level,
    required this.moves,
    required this.targetScore,
    required this.rewardCoins,
    required this.rewardGems,
    required this.starsRequired1,
    required this.starsRequired2,
    required this.starsRequired3,
    required this.obstacleType,
    required this.obstacleStrength,
  });

  factory LevelModel.fromLevel(int level) {
    ObstacleType obstacle = ObstacleType.none;

    if (level >= 31 && level <= 60) {
      obstacle = ObstacleType.frozenCrystal;
    } else if (level >= 61 && level <= 90) {
      obstacle = ObstacleType.shadowStone;
    } else if (level >= 91 && level <= 120) {
      obstacle = ObstacleType.energyLock;
    } else if (level >= 121 && level <= 150) {
      obstacle = ObstacleType.windBarrier;
    } else if (level >= 151 && level <= 180) {
      obstacle = ObstacleType.lavaCrystal;
    } else if (level >= 181 && level <= 210) {
      obstacle = ObstacleType.natureRoots;
    } else if (level >= 211 && level <= 240) {
      obstacle = ObstacleType.portalTile;
    } else if (level >= 241 && level <= 270) {
      obstacle = ObstacleType.moonCrystal;
    } else if (level >= 271 && level <= 300) {
      obstacle = ObstacleType.ancientMachine;
    } else if (level >= 301 && level <= 330) {
      obstacle = ObstacleType.stormCloud;
    } else if (level >= 331 && level <= 360) {
      obstacle = ObstacleType.mutationGem;
    } else if (level >= 361 && level <= 390) {
      obstacle = ObstacleType.waterFlow;
    } else if (level >= 391 && level <= 420) {
      obstacle = ObstacleType.titanBlock;
    } else if (level >= 421 && level <= 450) {
      obstacle = ObstacleType.cosmicRift;
    } else if (level >= 451) {
      obstacle = ObstacleType.kingdomBoss;
    }

    final difficultyStage = ((level - 1) ~/ 30);

    final moves =
        (30 - difficultyStage).clamp(12, 30);

    final targetScore =
        1000 + (level * 75);

    final rewardCoins =
        50 + (level * 5);

    final rewardGems =
        level % 10 == 0 ? 5 : 0;

    final star1 = targetScore;
    final star2 = (targetScore * 1.5).round();
    final star3 = (targetScore * 2).round();

    return LevelModel(
      level: level,
      moves: moves,
      targetScore: targetScore,
      rewardCoins: rewardCoins,
      rewardGems: rewardGems,
      starsRequired1: star1,
      starsRequired2: star2,
      starsRequired3: star3,
      obstacleType: obstacle,
      obstacleStrength:
          difficultyStage + 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'moves': moves,
      'targetScore': targetScore,
      'rewardCoins': rewardCoins,
      'rewardGems': rewardGems,
      'starsRequired1': starsRequired1,
      'starsRequired2': starsRequired2,
      'starsRequired3': starsRequired3,
      'obstacleType': obstacleType.name,
      'obstacleStrength': obstacleStrength,
    };
  }

  factory LevelModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return LevelModel(
      level: json['level'] ?? 1,
      moves: json['moves'] ?? 30,
      targetScore:
          json['targetScore'] ?? 1000,
      rewardCoins:
          json['rewardCoins'] ?? 50,
      rewardGems:
          json['rewardGems'] ?? 0,
      starsRequired1:
          json['starsRequired1'] ?? 1000,
      starsRequired2:
          json['starsRequired2'] ?? 1500,
      starsRequired3:
          json['starsRequired3'] ?? 2000,
      obstacleType: ObstacleType.values.firstWhere(
        (e) =>
            e.name ==
            json['obstacleType'],
        orElse: () => ObstacleType.none,
      ),
      obstacleStrength:
          json['obstacleStrength'] ?? 1,
    );
  }
}
