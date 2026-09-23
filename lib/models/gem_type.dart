enum GemType {
  fire,
  water,
  nature,
  storm,
  light,
  voidGem,
}

extension GemTypeExtension on GemType {
  String get emoji {
    switch (this) {
      case GemType.fire:
        return '🔥';

      case GemType.water:
        return '💧';

      case GemType.nature:
        return '🌿';

      case GemType.storm:
        return '⚡';

      case GemType.light:
        return '✨';

      case GemType.voidGem:
        return '🌌';
    }
  }

  String get nameLabel {
    switch (this) {
      case GemType.fire:
        return 'Fire';

      case GemType.water:
        return 'Water';

      case GemType.nature:
        return 'Nature';

      case GemType.storm:
        return 'Storm';

      case GemType.light:
        return 'Light';

      case GemType.voidGem:
        return 'Void';
    }
  }

  static GemType fromIndex(int index) {
    return GemType.values[
      index % GemType.values.length
    ];
  }
}
