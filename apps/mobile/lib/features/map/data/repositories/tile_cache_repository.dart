import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../persistence/tile_db.dart';

// Handles storing, retrieving, and clearing map tile data.
// Tiles are saved as files on disk with related metadata kept in the database.
class TileCacheRepository {
  TileCacheRepository(this.db);
  final AppDb db;

  Future<Uint8List?> get(String s, int z, int x, int y) async {
    final meta = await db.getMeta(s, z, x, y);
    if (meta == null) return null;
    final f = File(meta.path);
    if (!await f.exists()) return null;
    return await f.readAsBytes();
  }

  Future<void> put(
    String s,
    int z,
    int x,
    int y,
    Uint8List bytes, {
    String? etag,
    DateTime? lastModified,
    DateTime? expiresAt,
  }) async {
    final f = await _fileFor(s, z, x, y);
    await f.create(recursive: true);
    await f.writeAsBytes(bytes, flush: true);
    await db.upsertMeta(
      source: s,
      z: z,
      x: x,
      y: y,
      path: f.path,
      size: bytes.length,
      etag: etag,
      lastModified: lastModified,
      expiresAt: expiresAt,
    );
  }

  Future<void> clearAll() async {
    final dir = await _tilesBaseDir();
    if (await dir.exists()) await dir.delete(recursive: true);
    await db.customUpdate('DELETE FROM tiles', updates: {db.tiles});
    await db.customStatement('VACUUM');
  }

  Future<File> _fileFor(String s, int z, int x, int y) async {
    final base = await _tilesBaseDir();
    return File(p.join(base.path, s, '$z', '$x', '$y.png'));
  }

  Future<Directory> _tilesBaseDir() async {
    final d = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(d.path, 'tiles'));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }
}
