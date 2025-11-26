import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'data/repositories/map_style_repository.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';

class AreasLayerManager {
  MapboxMap? _map;
  StyleManager? get _style => _map?.style;
  bool _styleReady = false;
  List<Segment>? _lastSegments;
  final _styleRepo = MapStyleRepository();

  void attach(MapboxMap map) {
    _map = map;
  }

  Future<void> onStyleLoaded() async {
    if (_style == null) {
      return;
    }

    await _styleRepo.applyTerrainAndSky(_style!, exaggeration: 2.0);

    await _styleRepo.ensureAreasStyle(_style!, segments: _lastSegments ?? const []);
    _styleReady = true;
  }

  Future<void> setData(List<Segment> segments) async {
    _lastSegments = segments;
    if (!_styleReady || _style == null) {
      return;
    }
    await _styleRepo.setAreasData(_style!, segments);
  }

  Future<void> setHoveredId(String? id) async {
    if (!_styleReady || _style == null) return;
    await _styleRepo.setHoverFilter(_style!, id: id);
  }

  Future<void> setSelectedId(String? id) async {
    if (!_styleReady || _style == null) return;
    await _styleRepo.setSelectedFilter(_style!, id: id);
  }

  Future<void> setAreasVisible(bool visible) async {
    if (!_styleReady || _style == null) return;
    await _styleRepo.setAreasVisibility(_style!, visible: visible);
  }
}

final areasLayerManagerProvider =
    Provider.autoDispose<AreasLayerManager>((ref) {
  final m = AreasLayerManager();
  ref.onDispose(() {});
  return m;
});
