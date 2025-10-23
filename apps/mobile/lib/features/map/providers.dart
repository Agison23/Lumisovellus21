export 'viewmodel/map_notifier.dart' show mapStyleNotifierProvider, interactiveAreaNotifierProvider;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class AreasLayerManager {
  static const _sourceId = 'areas';
  static const _fillLayerId = 'areas-fill';
  static const _lineLayerId = 'areas-outline';

  MapLibreMapController? _c;
  bool _styleReady = false;
  bool _areasReady = false;
  Map<String, dynamic>? _lastFc;

  void attach(MapLibreMapController c) {
    _c = c;
  }

  Future<void> onStyleLoaded() async {
    _styleReady = true;
    _areasReady = false; // new style nukes previous layers
    await _recreateIfPossible();
  }

  Future<void> setData(Map<String, dynamic> fc) async {
    _lastFc = fc;
    if (!_styleReady || _c == null) return;

    if (!_areasReady) {
      await _recreateIfPossible();
      return;
    }

    try {
      await _c!.setGeoJsonSource(_sourceId, _lastFc!);
    } catch (_) {
      _areasReady = false;
      await _recreateIfPossible();
    }
  }

  Future<void> _recreateIfPossible() async {
    if (!_styleReady || _c == null || _lastFc == null) return;

    await _c!.addSource(_sourceId, GeojsonSourceProperties(data: _lastFc!));
    await _c!.addFillLayer(
      _sourceId,
      _fillLayerId,
      const FillLayerProperties(fillOpacity: 0.35, fillColor: '#2E86DE'),
    );
    await _c!.addLineLayer(
      _sourceId,
      _lineLayerId,
      const LineLayerProperties(lineWidth: 1.0, lineColor: '#2E86DE'),
    );

    _areasReady = true;
  }
}

final areasLayerManagerProvider = Provider.autoDispose<AreasLayerManager>((ref) {
  final m = AreasLayerManager();
  ref.onDispose(() {});
  return m;
});
