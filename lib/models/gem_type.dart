enum GemType {
  ruby,
  sapphire,
  emerald,
  topaz,
  amethyst,
  diamond,
}

extension GemTypeExtension on GemType {
  String get emoji {
    switch (this) {
      case GemType.ruby:
        return '🔴';

      case GemType.sapphire:
        return '🔵';

      case GemType.emerald:
        return '🟢';

      case GemType.topaz:
        return '🟡';

      case GemType.amethyst:
        return '🟣';

      case GemType.diamond:
        return '💎';
    }
  }

  String get nameLabel {
    switch (this) {
      case GemType.ruby:
        return 'Ruby';

      case GemType.sapphire:
        return 'Sapphire';

      case GemType.emerald:
        return 'Emerald';

      case GemType.topaz:
        return 'Topaz';

      case GemType.amethyst:
        return 'Amethyst';

      case GemType.diamond:
        return 'Diamond';
    }
  }
}
