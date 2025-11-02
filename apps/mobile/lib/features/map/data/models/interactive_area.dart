import 'geojson.dart';

class InteractiveAreaProperties {
  final String name;
  final String terrain;
  final bool avalancheDanger;
  final int? isLowerSegment;
  final String id;
  InteractiveAreaProperties({
    required this.name,
    required this.terrain,
    required this.avalancheDanger,
    required this.isLowerSegment,
    required this.id,
  });
  factory InteractiveAreaProperties.fromMap(Map<String, dynamic> m) =>
      InteractiveAreaProperties(
        name: m['name'],
        terrain: m['terrain'],
        avalancheDanger: m['avalancheDanger'],
        isLowerSegment: m['isLowerSegment'],
        id: m['id'],
      );
  Map<String, dynamic> toMap() => {
    'name': name,
    'terrain': terrain,
    'avalancheDanger': avalancheDanger,
    'isLowerSegment': isLowerSegment,
    'id': id,
  };
}

class InteractiveAreaFeature extends FeaturePolygon<InteractiveAreaProperties> {
  InteractiveAreaFeature({
    required super.type,
    required super.properties,
    required super.geometry,
  });
  factory InteractiveAreaFeature.fromMap(Map<String, dynamic> m) =>
      InteractiveAreaFeature(
        type: m['type'],
        properties: InteractiveAreaProperties.fromMap(m['properties']),
        geometry: PolygonGeometry.fromMap(m['geometry']),
      );
  Map<String, dynamic> toMap() => {
    'type': type,
    'properties': properties.toMap(),
    'geometry': geometry.toMap(),
  };
}
