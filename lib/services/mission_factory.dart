import '../models/mission_data.dart';

class MissionFactory {
  static MissionData create(int level) {
    if (level >= 90) {
      return const MissionData(
        title: 'Break Locked Tiles',
        target: 5,
      );
    }

    if (level >= 60) {
      return const MissionData(
        title: 'Break Blocks',
        target: 6,
      );
    }

    if (level >= 30) {
      return const MissionData(
        title: 'Break Ice',
        target: 4,
      );
    }

    return const MissionData(
      title: 'Reach Target Score',
      target: 1,
    );
  }
}
