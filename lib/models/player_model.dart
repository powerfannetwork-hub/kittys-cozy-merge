class PlayerModel {
  final String id;
  final String username;
  final String avatar;

  final int level;
  final int xp;

  final int coins;
  final int gems;

  final int lives;

  const PlayerModel({
    required this.id,
    required this.username,
    required this.avatar,
    required this.level,
    required this.xp,
    required this.coins,
    required this.gems,
    required this.lives,
  });

  factory PlayerModel.newPlayer() {
    return const PlayerModel(
      id: '',
      username: 'Player',
      avatar: '',
      level: 1,
      xp: 0,
      coins: 500,
      gems: 50,
      lives: 5,
    );
  }

  PlayerModel copyWith({
    String? id,
    String? username,
    String? avatar,
    int? level,
    int? xp,
    int? coins,
    int? gems,
    int? lives,
  }) {
    return PlayerModel(
      id: id ?? this.id,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      coins: coins ?? this.coins,
      gems: gems ?? this.gems,
      lives: lives ?? this.lives,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'avatar': avatar,
      'level': level,
      'xp': xp,
      'coins': coins,
      'gems': gems,
      'lives': lives,
    };
  }

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id'] ?? '',
      username: json['username'] ?? 'Player',
      avatar: json['avatar'] ?? '',
      level: json['level'] ?? 1,
      xp: json['xp'] ?? 0,
      coins: json['coins'] ?? 0,
      gems: json['gems'] ?? 0,
      lives: json['lives'] ?? 5,
    );
  }
}
