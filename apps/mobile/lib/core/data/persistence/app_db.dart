import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'tables/tiles.dart';
import 'tables/jobs.dart';

part 'app_db.g.dart';

LazyDatabase _open() => LazyDatabase(() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File(p.join(dir.path, 'app.sqlite'));
  return NativeDatabase.createInBackground(file);
});

@DriftDatabase(tables: [Tiles, Jobs])
class AppDb extends _$AppDb {
  AppDb() : super(_open());
  @override
  int get schemaVersion => 1;

  Future<Tile?> getTileMeta(String s, int z, int x, int y) async {
    final r =
        await (select(tiles)..where(
              (t) =>
                  t.source.equals(s) &
                  t.z.equals(z) &
                  t.x.equals(x) &
                  t.y.equals(y),
            ))
            .getSingleOrNull();
    if (r == null) return null;
    final now = DateTime.now().toUtc();
    if (r.expiresAt != null && r.expiresAt!.isBefore(now)) return null;
    return r;
  }

  Future<void> upsertTileMeta({
    required String source,
    required int z,
    required int x,
    required int y,
    required String path,
    required int size,
    String? etag,
    DateTime? lastModified,
    DateTime? expiresAt,
  }) => into(tiles).insertOnConflictUpdate(
    TilesCompanion(
      source: Value(source),
      z: Value(z),
      x: Value(x),
      y: Value(y),
      path: Value(path),
      size: Value(size),
      etag: Value(etag),
      lastModified: Value(lastModified?.toUtc()),
      expiresAt: Value(expiresAt?.toUtc()),
    ),
  );
}
