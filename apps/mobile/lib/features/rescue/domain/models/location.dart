class Location {
  final double latitude;
  final double longitude;
  final double accuracy;

  const Location({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Location &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          accuracy == other.accuracy;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode ^ accuracy.hashCode;
}

