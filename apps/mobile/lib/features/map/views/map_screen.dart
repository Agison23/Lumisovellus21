import 'package:geolocator/geolocator.dart' as geo;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisovellus/features/map/data/repositories/map_style_repository.dart';
import 'package:lumisovellus/features/map/viewmodel/map_notifier.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';
import 'package:lumisovellus/core/network/providers.dart';
import '../providers.dart';
import 'widgets/area_card.dart';
import 'widgets/filter_button.dart';
import 'widgets/location_picker.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});
  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  MapboxMap? _map;

  Future<void> _goToUserLocation() async {
    final enabled = await geo.Geolocator.isLocationServiceEnabled();
    if (!enabled) return;

    var perm = await geo.Geolocator.checkPermission();
    if (perm == geo.LocationPermission.denied) {
      perm = await geo.Geolocator.requestPermission();
    }
    if (perm == geo.LocationPermission.denied || perm == geo.LocationPermission.deniedForever) {
      return;
    }

    final pos = await geo.Geolocator.getCurrentPosition(
      locationSettings: const geo.LocationSettings(accuracy: geo.LocationAccuracy.high),
    );

    final cam = CameraOptions(
      center: Point(coordinates: Position(pos.longitude, pos.latitude)),
      zoom: 13,
      pitch: 0,
      bearing: 0,
    );
    _map?.easeTo(cam, MapAnimationOptions(duration: 500));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isOnline = ref.watch(connectivityProvider);
    final areasMgr = ref.watch(areasLayerManagerProvider);
    final snowTypesState = ref.watch(snowTypesNotifierProvider).value;
    final snowTypes = snowTypesState?.snowTypes ?? const <SnowType>[];

    final s = ref.watch(segmentsNotifierProvider).value;
    final segments = s?.segments ?? const [];
    final selectedSegment = segments.firstWhereOrNull((seg) => seg.id == s?.selectedId);

    ref.listen(
      segmentsNotifierProvider.select((a) => a.value?.selectedId),
      (_, id) {
        areasMgr.setSelectedId(id);
      },
    );

    ref.listen(
      segmentsNotifierProvider.select((a) => a.value?.hoveredId),
      (_, id) {
        areasMgr.setHoveredId(id);
      },
    );

    ref.listen(
      segmentsNotifierProvider.select((a) => a.value?.segments),
      (_, segs) {
        if (segs != null) areasMgr.setData(segs);
      },
    );

    // Listen for snap-to-location signal (when help event becomes active)
    ref.listen<bool>(
      snapToLocationProvider,
      (previous, next) {
        if (next && _map != null) {
          // Reset the signal and snap to location
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(snapToLocationProvider.notifier).state = false;
            _goToUserLocation();
          });
        }
      },
    );

    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            styleUri: 'mapbox://styles/mapbox/outdoors-v12',
            cameraOptions: CameraOptions(
              center: Point(coordinates: Position(24.07, 68.06)),
              zoom: 12,
              pitch: 60,
              bearing: 0,
            ),
            onTapListener: (ctx) async {
              if (_map == null) {
                return;
              }

              final geometry = RenderedQueryGeometry.fromScreenCoordinate(ctx.touchPosition);
              final options = RenderedQueryOptions(
                layerIds: [MapStyleRepository.areasFillId],
              );

              List<QueriedRenderedFeature>? features;
              try {
                features = (await _map!.queryRenderedFeatures(geometry, options)).cast<QueriedRenderedFeature>();
              } catch (e) {
                return;
              }

              final first = features.firstOrNull;

              final notifier = ref.read(segmentsNotifierProvider.notifier);
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
            },
            onStyleLoadedListener: (_) async {
              await _goToUserLocation();
              await _map?.location.updateSettings(
                LocationComponentSettings(
                  enabled: true,
                  pulsingEnabled: true,
                ),
              );
              final v = ref.read(segmentsNotifierProvider).value;
              await areasMgr.onStyleLoaded();
              if (v?.segments != null) {
                await areasMgr.setData(v!.segments!);
              }
              await areasMgr.setSelectedId(v?.selectedId);
              await areasMgr.setHoveredId(v?.hoveredId);
            },
          ),
          if (!isOnline)
            Positioned(
              left: 0,
              right: 0,
              bottom: 40,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    s?.segments == null ? t.mapOfflineModeMessageNoData : t.mapOfflineModeMessage,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          if (selectedSegment != null)
            Positioned(
              top: 32,
              left: 16,
              child: AreaCard(
                t: t,
                segmentId: selectedSegment.id,
                name: selectedSegment.name,
                terrain: selectedSegment.terrain,
                danger: selectedSegment.avalancheDanger
                    ? t.avalancheWarning
                    : t.noAvalancheWarning,
                userReviews: selectedSegment.userReviews,
                guideUpdate: selectedSegment.guideUpdate,
                onAdd: () {},
                onClose: () => ref.read(segmentsNotifierProvider.notifier).select(null),
                snowTypes: snowTypes,
                hazards: const ['stones', 'branches'],
              ),
            ),
          Positioned(
            bottom: 16,
            left: 16,
            child: FilterButton(t: t),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LocateButton(onLocate: _goToUserLocation),
                const SizedBox(height: 8),
                PlacesButton(
                  onLocationSelected: (cam) {
                    _map?.easeTo(cam, MapAnimationOptions(duration: 500));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
