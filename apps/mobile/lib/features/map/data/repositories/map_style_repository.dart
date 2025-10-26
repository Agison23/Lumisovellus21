import 'dart:convert';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapStyleRepository {
  static const demSourceId = 'mapbox-dem';
  static const areasSourceId = 'areas';

  static const hillshadeLayerId  = 'hillshade';
  static const skyLayerId = 'sky';

  static const areasFillId = 'areas-fill';
  static const areasHoverId = 'areas-hover';
  static const areasOutlineId = 'areas-outline';
  static const areasSelectedId = 'areas-selected';
  static const areasLabelsId = 'areas-labels';
  static const areasDangerId = 'areas-avalanche-danger-outline';

  /// Add DEM source + terrain + hillshade + sky
  Future<void> applyTerrainAndSky(
    StyleManager style, {
    double exaggeration = 2.0,
  }) async {
    if (await style.styleSourceExists(demSourceId)) {
      await style.removeStyleSource(demSourceId);
    }
    await style.addSource(
      RasterDemSource(
        id: demSourceId,
        url: 'mapbox://mapbox.mapbox-terrain-dem-v1',
        tileSize: 512,
        maxzoom: 14,
      ),
    );

    await style.setStyleTerrain(jsonEncode({
      "source": demSourceId,
      "exaggeration": exaggeration,
    }));

    if (await style.styleLayerExists(hillshadeLayerId)) {
      await style.removeStyleLayer(hillshadeLayerId);
    }
    await style.addLayer(HillshadeLayer(
      id: hillshadeLayerId,
      sourceId: demSourceId,
      hillshadeExaggeration: 1.0,
      visibility: Visibility.VISIBLE,
    ));

    if (await style.styleLayerExists(skyLayerId)) {
      await style.removeStyleLayer(skyLayerId);
    }
    await style.addLayer(SkyLayer(
      id: skyLayerId,
      skyType: SkyType.ATMOSPHERE,
      skyAtmosphereSunIntensity: 12.0,
    ));
  }

  // Recreate the `areas` GeoJSON source and all its layers.
  // `fcJson` can be String(JSON) or Map (FeatureCollection).
  Future<void> ensureAreasStyle(StyleManager style, {Object? fcJson}) async {
    final data = (fcJson is String) ? fcJson : jsonEncode(fcJson);

    for (final id in [
      areasLabelsId,
      areasSelectedId,
      areasHoverId,
      areasDangerId,
      areasOutlineId,
      areasFillId,
    ]) {
      if (await style.styleLayerExists(id)) {
        await style.removeStyleLayer(id);
      }
    }
    if (await style.styleSourceExists(areasSourceId)) {
      await style.removeStyleSource(areasSourceId);
    }

    await style.addSource(GeoJsonSource(id: areasSourceId, data: data));

    await style.addLayer(FillLayer(
      id: areasFillId,
      sourceId: areasSourceId,
      fillColor: 0xFFFFFFFF,
      fillOpacity: 0.1,
    ));

    await style.addLayer(FillLayer(
      id: areasHoverId,
      sourceId: areasSourceId,
      fillColor: 0xFFFFFFFF,
      fillOpacity: 0.3,
      filter: ["==", ["get", "id"], ""],
    ));

    await style.addLayer(LineLayer(
      id: areasOutlineId,
      sourceId: areasSourceId,
      lineColor: 0xFF2C3E50,
      lineWidth: 2.0,
      lineOpacity: 0.5,
    ));

    await style.addLayer(LineLayer(
      id: areasDangerId,
      sourceId: areasSourceId,
      lineColor: 0xFFFF0000,
      lineWidth: 3.0,
      filter: ["==", ["get", "avalancheDanger"], true],
    ));

    await style.addLayer(FillLayer(
      id: areasSelectedId,
      sourceId: areasSourceId,
      fillColor: 0xFF000000,
      fillOpacity: 0.2,
      filter: ["==", ["get", "id"], ""],
    ));

    await style.addLayer(SymbolLayer(
      id: areasLabelsId,
      sourceId: areasSourceId,
      textFieldExpression: ["get", "name"],
      textSize: 14.0,
      textOffset: const [0.0, 0.0],
      textColor: 0xFFFFFFFF,
      textHaloColor: 0xFF000000,
      textHaloWidth: 2.0,
    ));
  }

  // Update only the GeoJSON data (recreate if the source is missing).
  Future<void> setAreasData(StyleManager style, Object fcJson) async {
    final data = (fcJson is String) ? fcJson : jsonEncode(fcJson);
    final exists = await style.styleSourceExists(areasSourceId);
    if (!exists) {
      await ensureAreasStyle(style, fcJson: data);
      return;
    }
    await style.setStyleSourceProperty(areasSourceId, 'data', data);
  }

  // Filters for hover/selected
  Future<void> setHoverFilter(StyleManager style, {String? id}) async {
    if (!await style.styleLayerExists(areasHoverId)) return;
    await style.setStyleLayerProperty(areasHoverId, 'filter', ["==", ["coalesce", ["get", "id"], ["id"]], id ?? "__none__"]);
  }


  Future<void> setSelectedFilter(StyleManager style, {String? id}) async {
    if (!await style.styleLayerExists(areasSelectedId)) return;
    await style.setStyleLayerProperty(areasSelectedId, 'filter', ["==", ["coalesce", ["get", "id"], ["id"]], id ?? "__none__"]);
  }
}
