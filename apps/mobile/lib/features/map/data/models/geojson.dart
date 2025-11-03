class PolygonGeometry {
  final List<List<List<double>>> coordinates;
  PolygonGeometry({required this.coordinates});
  factory PolygonGeometry.fromMap(Map<String, dynamic> m) => PolygonGeometry(
    coordinates: (m['coordinates'] as List)
        .map(
          (ring) => (ring as List)
              .map(
                (pt) => (pt as List).map((n) => (n as num).toDouble()).toList(),
              )
              .toList(),
        )
        .toList(),
  );
  Map<String, dynamic> toMap() => {
    'type': 'Polygon',
    'coordinates': coordinates,
  };
}

class FeaturePolygon<P> {
  final String type;
  final P properties;
  final PolygonGeometry geometry;
  FeaturePolygon({
    required this.type,
    required this.properties,
    required this.geometry,
  });
}
