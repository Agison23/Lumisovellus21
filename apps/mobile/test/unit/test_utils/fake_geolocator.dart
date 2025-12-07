import 'package:geolocator/geolocator.dart';

void installFakeGeolocator({
  required bool serviceEnabled,
  required LocationPermission permission,
  required Position? position,
}) {
  GeolocatorPlatform.instance = FakeGeolocator(
    serviceEnabled: serviceEnabled,
    permission: permission,
    position: position,
  );
}

class FakeGeolocator extends GeolocatorPlatform {
  FakeGeolocator({
    required this.serviceEnabled,
    required this.permission,
    required this.position,
  });

  final bool serviceEnabled;
  final LocationPermission permission;
  final Position? position;

  @override
  Future<bool> isLocationServiceEnabled() async => serviceEnabled;

  @override
  Future<LocationPermission> checkPermission() async => permission;

  @override
  Future<LocationPermission> requestPermission() async => permission;

  @override
  Future<Position> getCurrentPosition({LocationSettings? locationSettings}) async {
    if (position == null) throw Exception('No position');
    return position!;
  }
}
