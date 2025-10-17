import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

import '../repositories/tile_cache_repository.dart';

// Local proxy for raster & dem tiles:
//   - GET /tiles/{osm|dem}/{z}/{x}/{y}.png
//   - serves cached bytes if present & not expired
//   - otherwise fetches from upstream, stores, and returns
class TileProxyServer {
  TileProxyServer(
    this.cache, {
    required this.osmBase,
    required this.demBase,
    http.Client? client,
    this.enableLogs = true,
  }) : _http = client ?? http.Client();

  final TileCacheRepository cache;
  final Uri osmBase;
  final Uri demBase;
  final http.Client _http;
  final bool enableLogs;

  HttpServer? _server;

  Future<Uri> start({String host = '127.0.0.1', int port = 0}) async {
    final handler = const Pipeline().addHandler(_route);
    _server = await io.serve(handler, host, port);
    final base = Uri.parse('http://$host:${_server!.port}/');
    _log('TileProxyServer started at $base');
    return base;
  }

  Future<void> stop() async {
    _log('TileProxyServer stopping…');
    await _server?.close(force: true);
    _server = null;
  }

  // -------------------- HTTP Handler --------------------

  Future<Response> _route(Request req) async {
    _log('# ${req.method} ${req.requestedUri}');

    if (req.method != 'GET') return Response(405);

    // Expect: /tiles/{osm|dem}/{z}/{x}/{y}.png
    final p = req.url.pathSegments;
    if (p.length != 5 || p.first != 'tiles') return _notFound();

    final src = p[1];
    if (src != 'osm' && src != 'dem') return _notFound();

    // Parse z/x/y
    final z = int.tryParse(p[2]);
    final x = int.tryParse(p[3]);
    final yStr = p[4].endsWith('.png') ? p[4].substring(0, p[4].length - 4) : p[4];
    final y = int.tryParse(yStr);
    if (z == null || x == null || y == null) return Response(400, body: 'Bad tile coords');

    // 1) Try cache
    final cached = await cache.get(src, z, x, y);
    if (cached != null) {
      _log('HIT $src/$z/$x/$y (cache len=${cached.length})');
      return Response.ok(
        cached,
        headers: {
          'Content-Type': 'image/png',
          // Still allow client to keep it; server-side expiry is already enforced by cache.get
          'Cache-Control': 'public, max-age=604800',
        },
      );
    }

    // 2) Fetch upstream
    final upstream = src == 'osm' ? osmBase : demBase;
    final upstreamUrl = upstream.resolve('$z/$x/$y.png');
    _log('MISS $src/$z/$x/$y -> FETCH $upstreamUrl');

    try {
      final r = await _http.get(upstreamUrl);
      if (r.statusCode != 200) {
        _log('UPSTREAM ${r.statusCode} for $upstreamUrl');
        return Response(r.statusCode, body: r.bodyBytes, headers: {
          'Content-Type': r.headers['content-type'] ?? 'application/octet-stream',
        });
      }

      final bytes = Uint8List.fromList(r.bodyBytes);
      final expiresAt = _parseMaxAgeToExpiry(r.headers['cache-control']);

      // Best-effort store (don’t fail the request if cache write throws)
      try {
        await cache.put(
          src,
          z,
          x,
          y,
          bytes,
          etag: r.headers['etag'],
          lastModified: _parseHttpDate(r.headers['last-modified']),
          expiresAt: expiresAt,
        );
      } catch (e) {
        _log('CACHE_WRITE_ERR $src/$z/$x/$y $e');
      }

      _log('FETCH_OK $src/$z/$x/$y len=${bytes.length} exp=$expiresAt');
      return Response.ok(
        bytes,
        headers: {
          'Content-Type': 'image/png',
          'Cache-Control': r.headers['cache-control'] ?? 'public, max-age=604800',
        },
      );
    } catch (e) {
      // Typically offline or TLS/host errors
      _log('FETCH_ERR $src/$z/$x/$y $e');
      return _notFound(body: 'offline-miss');
    }
  }

  // -------------------- Helpers --------------------

  void _log(Object msg) {
    if (enableLogs) debugPrint(msg.toString());
  }

  DateTime? _parseHttpDate(String? v) {
    if (v == null) return null;
    try {
      return HttpDate.parse(v);
    } catch (_) {
      return null;
    }
  }

  // One week by default
  DateTime _parseMaxAgeToExpiry(String? cacheControl) {
    final now = DateTime.now().toUtc();
    if (cacheControl == null) return now.add(const Duration(days: 7));
    final m = RegExp(r'max-age=(\d+)').firstMatch(cacheControl);
    if (m == null) return now.add(const Duration(days: 7));
    final secs = int.tryParse(m.group(1)!);
    if (secs == null) return now.add(const Duration(days: 7));
    return now.add(Duration(seconds: secs));
  }

  Response _notFound({String body = '404'}) => Response.notFound(body);
}
