import 'gem_type.dart';

class GemTile {
  final int row;
  final int column;

  GemType type;

  bool isMatched;

  bool isObstacle;

  GemTile({
    required this.row,
    required this.column,
    required this.type,
    this.isMatched = false,
    this.isObstacle = false,
  });

  GemTile copyWith({
    int? row,
    int? column,
    GemType? type,
    bool? isMatched,
    bool? isObstacle,
  }) {
    return GemTile(
      row: row ?? this.row,
      column: column ?? this.column,
      type: type ?? this.type,
      isMatched: isMatched ?? this.isMatched,
      isObstacle: isObstacle ?? this.isObstacle,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'row': row,
      'column': column,
      'type': type.name,
      'isMatched': isMatched,
      'isObstacle': isObstacle,
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
        orElse: () => GemType.fire,
      ),
      isMatched: json['isMatched'] ?? false,
      isObstacle: json['isObstacle'] ?? false,
    );
  }
}
