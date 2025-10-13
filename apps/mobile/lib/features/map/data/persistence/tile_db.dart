import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'tile_db.g.dart';

// Stores metadata for cached map tiles.
// Tiles themselves are stored as files on disk.
//
// Table: tiles
//
// Schema:
//
// source        TEXT        NOT NULL
// z             INTEGER     NOT NULL
// x             INTEGER     NOT NULL
// y             INTEGER     NOT NULL
// path          TEXT        NOT NULL
// size          INTEGER     NOT NULL
// etag          TEXT        NULL
// lastModified  DATETIME    NULL
// expiresAt     DATETIME    NULL
// PRIMARY KEY (source, z, x, y)
class Tiles extends Table {
  TextColumn get source => text()(); // e.g. 'osm' or 'dem'
  IntColumn get z => integer()(); // zoom
  IntColumn get x => integer()();
  IntColumn get y => integer()();
  TextColumn get path => text()(); // local file path
  IntColumn get size => integer()();
  TextColumn get etag => text().nullable()();
  DateTimeColumn get lastModified => dateTime().nullable()();
  DateTimeColumn get expiresAt => dateTime().nullable()();
  @override
  Set<Column> get primaryKey => {source, z, x, y};
}

LazyDatabase _open() => LazyDatabase(() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File(p.join(dir.path, 'tiles.sqlite'));
  return NativeDatabase(file);
});

@DriftDatabase(tables: [Tiles])
class AppDb extends _$AppDb {
  AppDb() : super(_open());
  @override
  int get schemaVersion => 1;

  Future<Tile?> getMeta(String s, int z, int x, int y) async {
    final r = await (select(tiles)
          ..where((t) => t.source.equals(s) & t.z.equals(z) & t.x.equals(x) & t.y.equals(y)))
        .getSingleOrNull();
    if (r == null) return null;
    final now = DateTime.now().toUtc();
    // TODO: Delete expired entries from DB & disk?
    if (r.expiresAt != null && r.expiresAt!.isBefore(now)) return null;
    return r;
  }

  Future<void> upsertMeta({
    required String source,
    required int z,
    required int x,
    required int y,
    required String path,
    required int size,
    String? etag,
    DateTime? lastModified,
    DateTime? expiresAt,
  }) =>
      into(tiles).insertOnConflictUpdate(TilesCompanion(
        source: Value(source),
        z: Value(z),
        x: Value(x),
        y: Value(y),
        path: Value(path),
        size: Value(size),
        etag: Value(etag),
        lastModified: Value(lastModified),
        expiresAt: Value(expiresAt),
      ));

  Future<void> clearAll() async {
    await delete(tiles).go();
  }
}
