import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';
import '../../../core/network/connectivity_provider.dart';
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
    final isOnline = ref.watch(connectivityProvider); // TODO: Show loading on startup
    final t = AppLocalizations.of(context);

    return Scaffold(
      body: Stack(
        children: [
          style.when(
            data: (s) => MapLibreMap(
              key: ValueKey(s.hashCode),
              styleString: s,
              onMapCreated: (c) => _controller = c,
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
          if (!isOnline)
            Positioned(
              left: 0,
              right: 0,
              bottom: 24,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    t.mapOfflineModeMessage,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
