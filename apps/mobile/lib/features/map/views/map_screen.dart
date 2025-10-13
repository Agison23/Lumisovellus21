import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import '../viewmodel/map_notifier.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});
  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  MapLibreMapController? _controller;

  @override
  Widget build(BuildContext context) {
    final style = ref.watch(mapStyleNotifierProvider);

    return Scaffold(
      body: style.when(
        data: (s) => MapLibreMap(
          key: ValueKey(s.hashCode),
          styleString: s,
          onMapCreated: (c) {
            _controller = c;
          },
          initialCameraPosition: const CameraPosition(
            target: LatLng(68.06, 24.07),
            zoom: 12,
          ),
          cameraTargetBounds: CameraTargetBounds(
            LatLngBounds(
              southwest: const LatLng(67.970, 23.725),
              northeast: const LatLng(68.162, 24.334),
            ),
          ),
          minMaxZoomPreference: const MinMaxZoomPreference(7, 18),
          rotateGesturesEnabled: true,
          tiltGesturesEnabled: false,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}
