// import 'dart:math';
// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';
import 'package:lumisovellus/core/network/connectivity_provider.dart';
import '../providers.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});
  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  MapboxMap? _map;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isOnline = ref.watch(connectivityProvider); // TODO: Refresh this properly on network change without recreating map
    final areasMgr = ref.watch(areasLayerManagerProvider);

    // Forward area updates into the manager (legal inside build with Riverpod)
    ref.listen(interactiveAreaNotifierProvider, (prev, next) {
      next.when(
        data: (fc) => areasMgr.setData(fc),
        loading: () {},
        error: (_, __) {},
      );
    });

    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            // Can be used to force recreation of the map, but should be careful so as not to waste sessions
            // key: Key(String.fromCharCodes(List.generate(5, (index) => Random().nextInt(33) + 89))),
            styleUri: 'mapbox://styles/mapbox/outdoors-v12',
            cameraOptions: CameraOptions(
              center: Point(coordinates: Position(24.07, 68.06)),
              zoom: 12,
              pitch: 60, // change for 3D view
              bearing: 0,
            ),
            onMapCreated: (controller) async {
              _map = controller;
              areasMgr.attach(controller);

              await controller.gestures.updateSettings(
                GesturesSettings(
                  pitchEnabled: true,
                  rotateEnabled: true,
                  scrollEnabled: true,
                ),
              );

              await controller.setBounds(
                CameraBoundsOptions(
                  bounds: CoordinateBounds(
                    southwest: Point(coordinates: Position(23.725, 67.970)),
                    northeast: Point(coordinates: Position(24.334, 68.162)),
                    infiniteBounds: false,
                  ),
                  minZoom: 7,
                  maxZoom: 18,
                ),
              );
            },
            onStyleLoadedListener: (_) async {
              await areasMgr.onStyleLoaded();
            },
          ),

           if (!isOnline)
             Positioned(
               left: 0, right: 0, bottom: 100,
               child: Center(
                 child: Container(
                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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