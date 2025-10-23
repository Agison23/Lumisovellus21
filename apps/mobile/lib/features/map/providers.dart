export 'viewmodel/map_notifier.dart' show interactiveAreaNotifierProvider;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class AreasLayerManager {
  static const _sourceId = 'areas';
  static const _fillLayerId = 'areas-fill';
  static const _lineLayerId = 'areas-outline';

  MapboxMap? _map;
  bool _styleReady = false;
  bool _areasReady = false;
  Map<String, dynamic>? _lastFc;

  void attach(MapboxMap map) {
    _map = map;
  }

  Future<void> onStyleLoaded() async {
    _styleReady = true;
    _areasReady = false;
    await _recreateIfPossible();
  }

  Future<void> setData(Map<String, dynamic> fc) async {
    _lastFc = fc;
    if (!_styleReady || _map == null) return;

    if (!_areasReady) {
      await _recreateIfPossible();
      return;
    }

    try {
      await _map!.style.setStyleSourceProperty(
        _sourceId,
        'data',
        jsonEncode(_lastFc),
      );
    } catch (_) {
      _areasReady = false;
      await _recreateIfPossible();
    }
  }

  Future<void> _recreateIfPossible() async {
    if (!_styleReady || _map == null || _lastFc == null) return;
    final style = _map!.style;

    try {
      if (await style.styleLayerExists(_fillLayerId)) {
        await style.removeStyleLayer(_fillLayerId);
      }
    } catch (_) {}
    try {
      if (await style.styleLayerExists(_lineLayerId)) {
        await style.removeStyleLayer(_lineLayerId);
      }
    } catch (_) {}
    try {
      if (await style.styleSourceExists(_sourceId)) {
        await style.removeStyleSource(_sourceId);
      }
    } catch (_) {}

    await style.addSource(
      GeoJsonSource(id: _sourceId, data: jsonEncode(_lastFc)),
    );

    await style.addLayer(
      FillLayer(
        id: _fillLayerId,
        sourceId: _sourceId,
        fillOpacity: 0.35,
        fillColor: 0xFF2E86DE,
      ),
    );

    await style.addLayer(
      LineLayer(
        id: _lineLayerId,
        sourceId: _sourceId,
        lineWidth: 1.0,
        lineColor: 0xFF2E86DE,
      ),
    );

    _areasReady = true;
  }
}

final areasLayerManagerProvider = Provider.autoDispose<AreasLayerManager>((
  ref,
) {
  final m = AreasLayerManager();
  ref.onDispose(() {});
  return m;
});
