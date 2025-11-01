class SnowType {
  final int id;
  final String name;
  final String colour;
  final int? skiability;
  final int? categoryId;
  final String explanation;

  SnowType({
    required this.id,
    required this.name,
    required this.colour,
    required this.skiability,
    required this.categoryId,
    required this.explanation,
  });

  factory SnowType.fromMap(Map<String, dynamic> m) => SnowType(
    id: m['id'] as int,
    name: m['name'] as String,
    colour: m['colour'] as String,
    skiability: m['skiability'] as int?,
    categoryId: m['categoryId'] as int?,
    explanation: m['explanation'] as String,
  );
}
