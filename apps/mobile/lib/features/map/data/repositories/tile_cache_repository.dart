import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:lumisovellus/core/data/persistence/app_db.dart';
import 'package:lumisovellus/core/data/persistence/daos/jobs_dao.dart';

/// WARNING: Legacy implementation.  
/// This repository is kept only as a reference for the Drift-based caching
/// pattern used in the app. For the full design and how new offline features
/// should be built, see docs/mobile/caching.md.
class TileCacheRepository {
  TileCacheRepository(this.db, this.jobs);
  final AppDb db;
  final JobsDao jobs;

  Future<Uint8List?> get(String s, int z, int x, int y) async {
    final meta = await db.getTileMeta(s, z, x, y);
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
    await f.writeAsBytes(bytes, flush: false);
    await jobs.enqueue(
      kind: 'tile.meta',
      dedupeKey: '$s/$z/$x/$y',
      priority: 1,
      payload: {
        'source': s,
        'z': z,
        'x': x,
        'y': y,
        'path': f.path,
        'etag': etag,
        'lastModified': lastModified?.toUtc().millisecondsSinceEpoch,
        'expiresAt': expiresAt?.toUtc().millisecondsSinceEpoch,
      },
    );
  }

  Future<void> clearAll() async {
    final dir = await _tilesBaseDir();
    if (await dir.exists()) await dir.delete(recursive: true);

    await db.delete(db.tiles).go();
    await db.delete(db.jobs).go();

    await db.customStatement('PRAGMA wal_checkpoint(TRUNCATE)');
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
