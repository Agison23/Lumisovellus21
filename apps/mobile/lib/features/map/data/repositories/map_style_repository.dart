import 'dart:convert';

// Builds a MapLibre style configuration that dynamically points tile sources
// either to local file URLs (for offline use) or to the localhost proxy server.
// Used for configuring raster and terrain layers in both offline and online modes.
class MapStyleRepository {
  Future<String> build({required Uri base, bool noTerrain = false}) async {
    final b = base.toString().endsWith('/') ? base.toString() : '${base.toString()}/';
    final isFile = base.scheme == 'file';
    final prefix = isFile ? '' : 'tiles/';

    final style = {
      'version': 8,
      'glyphs': '', // disable glyphs for now
      'sources': {
        'osm': {
          'type': 'raster',
          'tiles': ['${b}${prefix}osm/{z}/{x}/{y}.png'],
          'tileSize': 256,
          'maxzoom': 19,
          'attribution': '© OpenStreetMap contributors'
        },
        'terrainSource': {
          'type': 'raster-dem',
          'tiles': ['${b}${prefix}dem/{z}/{x}/{y}.png'],
          'tileSize': 256,
          'maxzoom': 15,
          'encoding': 'terrarium',
          'attribution': 'Terrain data © AWS Terrain Tiles'
        },
        'hillshadeSource': {
          'type': 'raster-dem',
          'tiles': ['${b}${prefix}dem/{z}/{x}/{y}.png'],
          'tileSize': 256,
          'maxzoom': 15,
          'encoding': 'terrarium',
          'attribution': 'Terrain data © AWS Terrain Tiles'
        }
      },
      'layers': [
        {
          'id': 'osm',
          'type': 'raster',
          'source': 'osm'
        },
        {
          'id': 'hills',
          'type': 'hillshade',
          'source': 'hillshadeSource',
          'layout': {'visibility': 'visible'},
          'paint': {'hillshade-shadow-color': '#473B24'}
        }
      ],
      'terrain': {
        'source': 'terrainSource',
        'exaggeration': 1,
      }
    };

    return jsonEncode(style);
  }
}
