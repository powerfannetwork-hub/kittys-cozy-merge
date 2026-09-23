class MissionService {
  static String getMissionText(int level) {
    if (level >= 90) {
      return 'Break Locked Tiles';
    }

    if (level >= 60) {
      return 'Break Blocks';
    }

    if (level >= 30) {
      return 'Break Ice';
    }

    return 'Reach Target Score';
  }

  static int getMissionTarget(int level) {
    if (level >= 90) {
      return 5;
    }

    if (level >= 60) {
      return 6;
    }

    if (level >= 30) {
      return 4;
    }

    return 1;
  }
}
