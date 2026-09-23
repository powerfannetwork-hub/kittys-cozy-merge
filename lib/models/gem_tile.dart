import 'gem_type.dart';

class GemTile {
  final int row;
  final int column;

  GemType type;

  bool isMatched;
  bool isObstacle;

  int iceHp;
  int blockHp;

  GemTile({
    required this.row,
    required this.column,
    required this.type,
    this.isMatched = false,
    this.isObstacle = false,
    this.iceHp = 0,
    this.blockHp = 0,
  });

  bool get hasIce => iceHp > 0;

  bool get hasBlock => blockHp > 0;

  GemTile copyWith({
    int? row,
    int? column,
    GemType? type,
    bool? isMatched,
    bool? isObstacle,
    int? iceHp,
    int? blockHp,
  }) {
    return GemTile(
      row: row ?? this.row,
      column: column ?? this.column,
      type: type ?? this.type,
      isMatched: isMatched ?? this.isMatched,
      isObstacle: isObstacle ?? this.isObstacle,
      iceHp: iceHp ?? this.iceHp,
      blockHp: blockHp ?? this.blockHp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'row': row,
      'column': column,
      'type': type.name,
      'isMatched': isMatched,
      'isObstacle': isObstacle,
      'iceHp': iceHp,
      'blockHp': blockHp,
    };
  }

  factory GemTile.fromJson(
    Map<String, dynamic> json,
  ) {
    return GemTile(
      row: json['row'] ?? 0,
      column: json['column'] ?? 0,
      type: GemType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => GemType.ruby,
      ),
      isMatched: json['isMatched'] ?? false,
      isObstacle: json['isObstacle'] ?? false,
      iceHp: json['iceHp'] ?? 0,
      blockHp: json['blockHp'] ?? 0,
    );
  }
}
