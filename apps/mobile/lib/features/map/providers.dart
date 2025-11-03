export 'viewmodel/map_notifier.dart' show interactiveAreaNotifierProvider, snowTypesNotifierProvider;

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'data/repositories/map_style_repository.dart';

class AreasLayerManager {
  MapboxMap? _map;
  StyleManager? get _style => _map?.style;
  bool _styleReady = false;
  Map<String, dynamic>? _lastFc;
  final _styleRepo = MapStyleRepository();

  void attach(MapboxMap map) {
    _map = map;
  }

  Future<void> onStyleLoaded() async {
    _styleReady = true;
    if (_style == null) return;

    await _styleRepo.applyTerrainAndSky(_style!, exaggeration: 2.0);

    if (_lastFc != null) {
      await _styleRepo.ensureAreasStyle(_style!, fcJson: _lastFc);
    }
  }

  Future<void> setData(Map<String, dynamic> fc) async {
    _lastFc = fc;
    if (!_styleReady || _style == null) return;
    await _styleRepo.setAreasData(_style!, jsonEncode(fc));
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

final areasLayerManagerProvider = Provider.autoDispose<AreasLayerManager>((
  ref,
) {
  final m = AreasLayerManager();
  ref.onDispose(() {});
  return m;
});
