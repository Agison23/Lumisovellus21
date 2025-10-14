import 'package:drift/drift.dart';

class Jobs extends Table {
  TextColumn get id => text()();
  TextColumn get kind => text()();
  TextColumn get payload => text()();
  TextColumn get status => text().withDefault(const Constant('queued'))();
  IntColumn get priority => integer().withDefault(const Constant(0))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  IntColumn get maxAttempts => integer().withDefault(const Constant(5))();
  IntColumn get nextRunAt => integer()();
  TextColumn get dedupeKey => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
