import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';
import 'package:lumisovellus/core/network/connectivity_provider.dart';
import '../providers.dart';
import 'widgets/area_card.dart';
import 'widgets/filter_button.dart';

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
    final snowTypes = ref.watch(snowTypesNotifierProvider).value ?? const [];

    final s = ref.watch(interactiveAreaNotifierProvider).value;
    final features = (s?.fc?['features'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
    final selected = features.firstWhereOrNull((f) {
      final id = f['id']?.toString() ?? ((f['properties'] as Map?)?['id']?.toString());
      return id == s?.selectedId;
    });

    ref.listen(interactiveAreaNotifierProvider.select((a) => a.value?.selectedId), (_, id) {
      areasMgr.setSelectedId(id);
    });

    ref.listen(interactiveAreaNotifierProvider.select((a) => a.value?.hoveredId), (_, id) {
      areasMgr.setHoveredId(id);
    });

    ref.listen(interactiveAreaNotifierProvider.select((a) => a.value?.fc), (_, fc) {
      if (fc != null) areasMgr.setData(fc);
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
            onTapListener: (ctx) async {
              if (_map == null) return;

              final geometry = RenderedQueryGeometry.fromScreenCoordinate(ctx.touchPosition);
              final options = RenderedQueryOptions(layerIds: ['areas-fill']);
              final features = await _map!.queryRenderedFeatures(geometry, options);

              final first = features.firstOrNull;
              final notifier = ref.read(interactiveAreaNotifierProvider.notifier);
              if (first == null) {
                await areasMgr.setSelectedId(null);
                notifier.select(null);
                return;
              }

              final feature = first.queriedFeature.feature;
              final id = feature['id']?.toString() ??
                  (feature['properties'] is Map ? (feature['properties'] as Map)['id']?.toString() : null);

              notifier.select(id);
            },
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
              final v = ref.read(interactiveAreaNotifierProvider).value;
              await areasMgr.onStyleLoaded();
              if (v?.fc != null) await areasMgr.setData(v!.fc!);
              await areasMgr.setSelectedId(v?.selectedId);
              await areasMgr.setHoveredId(v?.hoveredId);
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
             
          if (selected != null)
            Positioned(
              top: 32,
              left: 16,
              child: AreaCard(
                t: t,
                name: (selected['properties'] as Map?)?['name']?.toString() ?? '',
                terrain: (selected['properties'] as Map?)?['terrain']?.toString() ?? '',
                danger: ((selected['properties'] as Map?)?['avalancheDanger'] == true)
                    ? t.avalancheWarning
                    : t.noAvalancheWarning,
                snowTypes: snowTypes,
                onAdd: () {},
                onClose: () => ref.read(interactiveAreaNotifierProvider.notifier).select(null),
              ),
            ),

          Positioned(
            bottom: 16,
            left: 16,
            child: FilterButton(t: t),
          )
        ],
      ),
    );
  }
}