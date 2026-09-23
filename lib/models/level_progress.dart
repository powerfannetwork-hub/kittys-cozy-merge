class LevelProgress {
  final int currentLevel;

  final int bestScore;

  final int stars;

  final int unlockedLevel;

  const LevelProgress({
    required this.currentLevel,
    required this.bestScore,
    required this.stars,
    required this.unlockedLevel,
  });

  factory LevelProgress.initial() {
    return const LevelProgress(
      currentLevel: 1,
      bestScore: 0,
      stars: 0,
      unlockedLevel: 1,
    );
  }

  LevelProgress copyWith({
    int? currentLevel,
    int? bestScore,
    int? stars,
    int? unlockedLevel,
  }) {
    return LevelProgress(
      currentLevel:
          currentLevel ?? this.currentLevel,
      bestScore: bestScore ?? this.bestScore,
      stars: stars ?? this.stars,
      unlockedLevel:
          unlockedLevel ?? this.unlockedLevel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentLevel': currentLevel,
      'bestScore': bestScore,
      'stars': stars,
      'unlockedLevel': unlockedLevel,
    };
  }

  factory LevelProgress.fromJson(
    Map<String, dynamic> json,
  ) {
    return LevelProgress(
      currentLevel:
          json['currentLevel'] ?? 1,
      bestScore:
          json['bestScore'] ?? 0,
      stars:
          json['stars'] ?? 0,
      unlockedLevel:
          json['unlockedLevel'] ?? 1,
    );
  }
}
