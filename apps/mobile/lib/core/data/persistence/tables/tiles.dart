import 'package:drift/drift.dart';

class Tiles extends Table {
  TextColumn get source => text()();
  IntColumn get z => integer()();
  IntColumn get x => integer()();
  IntColumn get y => integer()();
  TextColumn get path => text()();
  IntColumn get size => integer()();
  TextColumn get etag => text().nullable()();
  DateTimeColumn get lastModified => dateTime().nullable()();
  DateTimeColumn get expiresAt => dateTime().nullable()();
  @override
  Set<Column> get primaryKey => {source, z, x, y};
}
