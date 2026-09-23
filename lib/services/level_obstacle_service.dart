import 'dart:math';

class LevelObstacleService {
  static final Random _random = Random();

  /// Ice ya fara bayyana daga Level 30.
  ///
  /// Amma ba ya bayyana a kowane level.
  /// Wasu levels suna normal domin a samu sauƙin wasa.
  static bool shouldHaveIce(int level) {
    if (level < 30) {
      return false;
    }

    // Level 30 yana koyar da Ice.
    if (level == 30) {
      return true;
    }

    // Bayan haka Ice yana bayyana lokaci-lokaci.
    // Wasu levels normal ne.
    final difficultyRoll = _random.nextInt(100);

    if (level < 60) {
      // 30-59: Ice yana bayyana kusan 45% na levels.
      return difficultyRoll < 45;
    }

    if (level < 90) {
      // 60-89: Ice kusan 50%.
      return difficultyRoll < 50;
    }

    if (level < 120) {
      // 90-119: Ice kusan 55%.
      return difficultyRoll < 55;
    }

    // Higher levels: Ice yana iya bayyana kusan 60%.
    return difficultyRoll < 60;
  }

  /// Yawan Ice a level.
  ///
  /// Ba kowane level bane zai samu yawan Ice iri ɗaya.
  static int getIceCount(int level) {
    if (!shouldHaveIce(level)) {
      return 0;
    }

    if (level == 30) {
      return 3;
    }

    if (level < 60) {
      // Easy / medium Ice.
      return 2 + _random.nextInt(4); // 2-5
    }

    if (level < 90) {
      return 3 + _random.nextInt(5); // 3-7
    }

    if (level < 120) {
      return 4 + _random.nextInt(5); // 4-8
    }

    return 5 + _random.nextInt(6); // 5-10
  }

  /// HP na Ice.
  ///
  /// HP yana ƙaruwa a hankali amma ba lallai
  /// kowane level ya kasance mai wahala ba.
  static int getIceHp(int level) {
    if (level < 30) {
      return 0;
    }

    if (level < 60) {
      return 2;
    }

    if (level < 120) {
      return 2 + (level % 3 == 0 ? 1 : 0);
    }

    if (level < 180) {
      return 3;
    }

    return 3 + (level % 5 == 0 ? 1 : 0);
  }
}
