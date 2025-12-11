import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'package:lumisovellus_api/lumisovellus_api.dart';
import 'package:lumisovellus/features/map/data/repositories/map_style_repository.dart';

class RecordingStyleManager extends Fake implements StyleManager {
  final Map<String, Map<String, dynamic>> sources = {};
  final Map<String, Map<String, dynamic>> layers = {};
  final Map<String, Map<String, dynamic>> layerProperties = {};

  String? terrainJson;

  @override
  Future<bool> styleSourceExists(String sourceId) async {
    return sources.containsKey(sourceId);
  }

  @override
  Future<void> removeStyleSource(String sourceId) async {
    sources.remove(sourceId);
  }

  @override
  Future<void> addStyleSource(String sourceId, String propertiesJson) async {
    final map = jsonDecode(propertiesJson) as Map<String, dynamic>;
    sources[sourceId] = map;
  }

  @override
  Future<void> setStyleSourceProperties(
    String sourceId,
    String propertiesJson,
  ) async {
    final map = jsonDecode(propertiesJson) as Map<String, dynamic>;
    sources[sourceId] = map;
  }

  @override
  Future<void> setStyleSourceProperty(
    String sourceId,
    String property,
    Object? value,
  ) async {
    final src = sources.putIfAbsent(sourceId, () => {});
    if (property == 'data' && value is String) {
      src[property] = jsonDecode(value);
    } else {
      src[property] = value;
    }
  }

  @override
  Future<void> setStyleTerrain(String json) async {
    terrainJson = json;
  }

  @override
  Future<bool> styleLayerExists(String layerId) async {
    return layers.containsKey(layerId);
  }

  @override
  Future<void> removeStyleLayer(String layerId) async {
    layers.remove(layerId);
  }

  @override
  Future<void> addStyleLayer(
    String properties,
    LayerPosition? layerPosition,
  ) async {
    final map = jsonDecode(properties) as Map<String, dynamic>;
    final id = map['id'] as String;
    layers[id] = map;
  }

  @override
  Future<void> setStyleLayerProperty(
    String layerId,
    String property,
    Object? value,
  ) async {
    final props = layerProperties.putIfAbsent(layerId, () => {});
    props[property] = value;
  }
}

Segment _seg(String id, String name) => Segment(
  id: id,
  name: name,
  terrain: 'Terrain',
  avalancheDanger: false,
  isLowerSegment: null,
  points: const [],
  guideUpdate: null,
  userReviews: const [],
);

void main() {
  late MapStyleRepository repo;
  late RecordingStyleManager style;

  setUp(() {
    repo = MapStyleRepository();
    style = RecordingStyleManager();
  });

  group('ensureAreasStyle', () {
    test('creates GeoJSON source and filters out Metsä segment', () async {
      final segments = [_seg('1', 'Metsä'), _seg('2', 'Laukukero itäseinä')];

      await repo.ensureAreasStyle(style, segments: segments);

      expect(
        style.sources.containsKey(MapStyleRepository.areasSourceId),
        isTrue,
      );

      final source = style.sources[MapStyleRepository.areasSourceId]!;
      final dataField = source['data'];

      final fc = dataField is String
          ? jsonDecode(dataField) as Map<String, dynamic>
          : dataField as Map<String, dynamic>;

      final features = fc['features'] as List<dynamic>;
      expect(features.length, 1);

      final props = features.first['properties'] as Map<String, dynamic>;
      expect(props['name'], 'Laukukero itäseinä');
    });
  });

  group('setAreasData', () {
    test('recreates style when source does not exist', () async {
      final segments = [_seg('1', 'A')];

      expect(
        style.sources.containsKey(MapStyleRepository.areasSourceId),
        isFalse,
      );

      await repo.setAreasData(style, segments);

      expect(
        style.sources.containsKey(MapStyleRepository.areasSourceId),
        isTrue,
      );
    });

    test('updates source data when source exists', () async {
      final initialSegments = [_seg('1', 'Old')];
      final newSegments = [_seg('2', 'New')];

      await repo.ensureAreasStyle(style, segments: initialSegments);
      expect(
        style.sources.containsKey(MapStyleRepository.areasSourceId),
        isTrue,
      );

      await repo.setAreasData(style, newSegments);

      final source = style.sources[MapStyleRepository.areasSourceId]!;
      final dataField = source['data'];

      final fc = dataField is String
          ? jsonDecode(dataField) as Map<String, dynamic>
          : dataField as Map<String, dynamic>;

      final features = fc['features'] as List<dynamic>;
      expect(features.length, 1);

      final props = features.first['properties'] as Map<String, dynamic>;
      expect(props['name'], 'New');
    });
  });

  group('setHoverFilter', () {
    test('does nothing when hover layer does not exist', () async {
      await repo.setHoverFilter(style, id: 's1');

      expect(style.layerProperties[MapStyleRepository.areasHoverId], isNull);
    });

    test('sets filter when hover layer exists', () async {
      await repo.ensureAreasStyle(style, segments: []);

      await repo.setHoverFilter(style, id: 's1');

      final props =
          style.layerProperties[MapStyleRepository.areasHoverId] ?? {};
      final filter = props['filter'] as List<dynamic>;
      expect(filter.first, '==');
      expect(filter.last, 's1');
    });

    test('uses __none__ when id is null', () async {
      await repo.ensureAreasStyle(style, segments: []);

      await repo.setHoverFilter(style, id: null);

      final props =
          style.layerProperties[MapStyleRepository.areasHoverId] ?? {};
      final filter = props['filter'] as List<dynamic>;
      expect(filter.last, '__none__');
    });
  });

  group('setSelectedFilter', () {
    test('does nothing when selected layer does not exist', () async {
      await repo.setSelectedFilter(style, id: 's1');

      expect(style.layerProperties[MapStyleRepository.areasSelectedId], isNull);
    });

    test('sets filter when selected layer exists', () async {
      await repo.ensureAreasStyle(style, segments: []);

      await repo.setSelectedFilter(style, id: 's1');

      final props =
          style.layerProperties[MapStyleRepository.areasSelectedId] ?? {};
      final filter = props['filter'] as List<dynamic>;
      expect(filter.first, '==');
      expect(filter.last, 's1');
    });
  });

  group('setAreasVisibility', () {
    test('sets visibility on all existing layers', () async {
      await repo.ensureAreasStyle(style, segments: []);

      await repo.setAreasVisibility(style, visible: true);

      const ids = [
        MapStyleRepository.areasFillId,
        MapStyleRepository.areasHoverId,
        MapStyleRepository.areasOutlineId,
        MapStyleRepository.areasDangerId,
        MapStyleRepository.areasSelectedId,
        MapStyleRepository.areasLabelsId,
      ];

      for (final id in ids) {
        final props = style.layerProperties[id] ?? {};
        expect(props['visibility'], 'visible');
      }

      await repo.setAreasVisibility(style, visible: false);

      for (final id in ids) {
        final props = style.layerProperties[id] ?? {};
        expect(props['visibility'], 'none');
      }
    });

    test('skips layers that do not exist', () async {
      style.layers[MapStyleRepository.areasFillId] = {};

      await repo.setAreasVisibility(style, visible: true);

      final fillProps =
          style.layerProperties[MapStyleRepository.areasFillId] ?? {};
      expect(fillProps['visibility'], 'visible');

      expect(style.layerProperties[MapStyleRepository.areasHoverId], isNull);
    });
  });
}
