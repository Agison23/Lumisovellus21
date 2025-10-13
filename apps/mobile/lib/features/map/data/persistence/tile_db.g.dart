// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tile_db.dart';

// ignore_for_file: type=lint
class $TilesTable extends Tiles with TableInfo<$TilesTable, Tile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _zMeta = const VerificationMeta('z');
  @override
  late final GeneratedColumn<int> z = GeneratedColumn<int>(
    'z',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _xMeta = const VerificationMeta('x');
  @override
  late final GeneratedColumn<int> x = GeneratedColumn<int>(
    'x',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yMeta = const VerificationMeta('y');
  @override
  late final GeneratedColumn<int> y = GeneratedColumn<int>(
    'y',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
    'size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _etagMeta = const VerificationMeta('etag');
  @override
  late final GeneratedColumn<String> etag = GeneratedColumn<String>(
    'etag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    source,
    z,
    x,
    y,
    path,
    size,
    etag,
    lastModified,
    expiresAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('z')) {
      context.handle(_zMeta, z.isAcceptableOrUnknown(data['z']!, _zMeta));
    } else if (isInserting) {
      context.missing(_zMeta);
    }
    if (data.containsKey('x')) {
      context.handle(_xMeta, x.isAcceptableOrUnknown(data['x']!, _xMeta));
    } else if (isInserting) {
      context.missing(_xMeta);
    }
    if (data.containsKey('y')) {
      context.handle(_yMeta, y.isAcceptableOrUnknown(data['y']!, _yMeta));
    } else if (isInserting) {
      context.missing(_yMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('size')) {
      context.handle(
        _sizeMeta,
        size.isAcceptableOrUnknown(data['size']!, _sizeMeta),
      );
    } else if (isInserting) {
      context.missing(_sizeMeta);
    }
    if (data.containsKey('etag')) {
      context.handle(
        _etagMeta,
        etag.isAcceptableOrUnknown(data['etag']!, _etagMeta),
      );
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {source, z, x, y};
  @override
  Tile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tile(
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      z: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}z'],
      )!,
      x: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}x'],
      )!,
      y: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}y'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      size: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size'],
      )!,
      etag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etag'],
      ),
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified'],
      ),
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      ),
    );
  }

  @override
  $TilesTable createAlias(String alias) {
    return $TilesTable(attachedDatabase, alias);
  }
}

class Tile extends DataClass implements Insertable<Tile> {
  final String source;
  final int z;
  final int x;
  final int y;
  final String path;
  final int size;
  final String? etag;
  final DateTime? lastModified;
  final DateTime? expiresAt;
  const Tile({
    required this.source,
    required this.z,
    required this.x,
    required this.y,
    required this.path,
    required this.size,
    this.etag,
    this.lastModified,
    this.expiresAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['source'] = Variable<String>(source);
    map['z'] = Variable<int>(z);
    map['x'] = Variable<int>(x);
    map['y'] = Variable<int>(y);
    map['path'] = Variable<String>(path);
    map['size'] = Variable<int>(size);
    if (!nullToAbsent || etag != null) {
      map['etag'] = Variable<String>(etag);
    }
    if (!nullToAbsent || lastModified != null) {
      map['last_modified'] = Variable<DateTime>(lastModified);
    }
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    return map;
  }

  TilesCompanion toCompanion(bool nullToAbsent) {
    return TilesCompanion(
      source: Value(source),
      z: Value(z),
      x: Value(x),
      y: Value(y),
      path: Value(path),
      size: Value(size),
      etag: etag == null && nullToAbsent ? const Value.absent() : Value(etag),
      lastModified: lastModified == null && nullToAbsent
          ? const Value.absent()
          : Value(lastModified),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
    );
  }

  factory Tile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tile(
      source: serializer.fromJson<String>(json['source']),
      z: serializer.fromJson<int>(json['z']),
      x: serializer.fromJson<int>(json['x']),
      y: serializer.fromJson<int>(json['y']),
      path: serializer.fromJson<String>(json['path']),
      size: serializer.fromJson<int>(json['size']),
      etag: serializer.fromJson<String?>(json['etag']),
      lastModified: serializer.fromJson<DateTime?>(json['lastModified']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'source': serializer.toJson<String>(source),
      'z': serializer.toJson<int>(z),
      'x': serializer.toJson<int>(x),
      'y': serializer.toJson<int>(y),
      'path': serializer.toJson<String>(path),
      'size': serializer.toJson<int>(size),
      'etag': serializer.toJson<String?>(etag),
      'lastModified': serializer.toJson<DateTime?>(lastModified),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
    };
  }

  Tile copyWith({
    String? source,
    int? z,
    int? x,
    int? y,
    String? path,
    int? size,
    Value<String?> etag = const Value.absent(),
    Value<DateTime?> lastModified = const Value.absent(),
    Value<DateTime?> expiresAt = const Value.absent(),
  }) => Tile(
    source: source ?? this.source,
    z: z ?? this.z,
    x: x ?? this.x,
    y: y ?? this.y,
    path: path ?? this.path,
    size: size ?? this.size,
    etag: etag.present ? etag.value : this.etag,
    lastModified: lastModified.present ? lastModified.value : this.lastModified,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
  );
  Tile copyWithCompanion(TilesCompanion data) {
    return Tile(
      source: data.source.present ? data.source.value : this.source,
      z: data.z.present ? data.z.value : this.z,
      x: data.x.present ? data.x.value : this.x,
      y: data.y.present ? data.y.value : this.y,
      path: data.path.present ? data.path.value : this.path,
      size: data.size.present ? data.size.value : this.size,
      etag: data.etag.present ? data.etag.value : this.etag,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tile(')
          ..write('source: $source, ')
          ..write('z: $z, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('path: $path, ')
          ..write('size: $size, ')
          ..write('etag: $etag, ')
          ..write('lastModified: $lastModified, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(source, z, x, y, path, size, etag, lastModified, expiresAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tile &&
          other.source == this.source &&
          other.z == this.z &&
          other.x == this.x &&
          other.y == this.y &&
          other.path == this.path &&
          other.size == this.size &&
          other.etag == this.etag &&
          other.lastModified == this.lastModified &&
          other.expiresAt == this.expiresAt);
}

class TilesCompanion extends UpdateCompanion<Tile> {
  final Value<String> source;
  final Value<int> z;
  final Value<int> x;
  final Value<int> y;
  final Value<String> path;
  final Value<int> size;
  final Value<String?> etag;
  final Value<DateTime?> lastModified;
  final Value<DateTime?> expiresAt;
  final Value<int> rowid;
  const TilesCompanion({
    this.source = const Value.absent(),
    this.z = const Value.absent(),
    this.x = const Value.absent(),
    this.y = const Value.absent(),
    this.path = const Value.absent(),
    this.size = const Value.absent(),
    this.etag = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TilesCompanion.insert({
    required String source,
    required int z,
    required int x,
    required int y,
    required String path,
    required int size,
    this.etag = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : source = Value(source),
       z = Value(z),
       x = Value(x),
       y = Value(y),
       path = Value(path),
       size = Value(size);
  static Insertable<Tile> custom({
    Expression<String>? source,
    Expression<int>? z,
    Expression<int>? x,
    Expression<int>? y,
    Expression<String>? path,
    Expression<int>? size,
    Expression<String>? etag,
    Expression<DateTime>? lastModified,
    Expression<DateTime>? expiresAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (source != null) 'source': source,
      if (z != null) 'z': z,
      if (x != null) 'x': x,
      if (y != null) 'y': y,
      if (path != null) 'path': path,
      if (size != null) 'size': size,
      if (etag != null) 'etag': etag,
      if (lastModified != null) 'last_modified': lastModified,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TilesCompanion copyWith({
    Value<String>? source,
    Value<int>? z,
    Value<int>? x,
    Value<int>? y,
    Value<String>? path,
    Value<int>? size,
    Value<String?>? etag,
    Value<DateTime?>? lastModified,
    Value<DateTime?>? expiresAt,
    Value<int>? rowid,
  }) {
    return TilesCompanion(
      source: source ?? this.source,
      z: z ?? this.z,
      x: x ?? this.x,
      y: y ?? this.y,
      path: path ?? this.path,
      size: size ?? this.size,
      etag: etag ?? this.etag,
      lastModified: lastModified ?? this.lastModified,
      expiresAt: expiresAt ?? this.expiresAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (z.present) {
      map['z'] = Variable<int>(z.value);
    }
    if (x.present) {
      map['x'] = Variable<int>(x.value);
    }
    if (y.present) {
      map['y'] = Variable<int>(y.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (etag.present) {
      map['etag'] = Variable<String>(etag.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TilesCompanion(')
          ..write('source: $source, ')
          ..write('z: $z, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('path: $path, ')
          ..write('size: $size, ')
          ..write('etag: $etag, ')
          ..write('lastModified: $lastModified, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  $AppDbManager get managers => $AppDbManager(this);
  late final $TilesTable tiles = $TilesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [tiles];
}

typedef $$TilesTableCreateCompanionBuilder =
    TilesCompanion Function({
      required String source,
      required int z,
      required int x,
      required int y,
      required String path,
      required int size,
      Value<String?> etag,
      Value<DateTime?> lastModified,
      Value<DateTime?> expiresAt,
      Value<int> rowid,
    });
typedef $$TilesTableUpdateCompanionBuilder =
    TilesCompanion Function({
      Value<String> source,
      Value<int> z,
      Value<int> x,
      Value<int> y,
      Value<String> path,
      Value<int> size,
      Value<String?> etag,
      Value<DateTime?> lastModified,
      Value<DateTime?> expiresAt,
      Value<int> rowid,
    });

class $$TilesTableFilterComposer extends Composer<_$AppDb, $TilesTable> {
  $$TilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get z => $composableBuilder(
    column: $table.z,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get x => $composableBuilder(
    column: $table.x,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get y => $composableBuilder(
    column: $table.y,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TilesTableOrderingComposer extends Composer<_$AppDb, $TilesTable> {
  $$TilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get z => $composableBuilder(
    column: $table.z,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get x => $composableBuilder(
    column: $table.x,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get y => $composableBuilder(
    column: $table.y,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TilesTableAnnotationComposer extends Composer<_$AppDb, $TilesTable> {
  $$TilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get z =>
      $composableBuilder(column: $table.z, builder: (column) => column);

  GeneratedColumn<int> get x =>
      $composableBuilder(column: $table.x, builder: (column) => column);

  GeneratedColumn<int> get y =>
      $composableBuilder(column: $table.y, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<int> get size =>
      $composableBuilder(column: $table.size, builder: (column) => column);

  GeneratedColumn<String> get etag =>
      $composableBuilder(column: $table.etag, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);
}

class $$TilesTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $TilesTable,
          Tile,
          $$TilesTableFilterComposer,
          $$TilesTableOrderingComposer,
          $$TilesTableAnnotationComposer,
          $$TilesTableCreateCompanionBuilder,
          $$TilesTableUpdateCompanionBuilder,
          (Tile, BaseReferences<_$AppDb, $TilesTable, Tile>),
          Tile,
          PrefetchHooks Function()
        > {
  $$TilesTableTableManager(_$AppDb db, $TilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> source = const Value.absent(),
                Value<int> z = const Value.absent(),
                Value<int> x = const Value.absent(),
                Value<int> y = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<int> size = const Value.absent(),
                Value<String?> etag = const Value.absent(),
                Value<DateTime?> lastModified = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TilesCompanion(
                source: source,
                z: z,
                x: x,
                y: y,
                path: path,
                size: size,
                etag: etag,
                lastModified: lastModified,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String source,
                required int z,
                required int x,
                required int y,
                required String path,
                required int size,
                Value<String?> etag = const Value.absent(),
                Value<DateTime?> lastModified = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TilesCompanion.insert(
                source: source,
                z: z,
                x: x,
                y: y,
                path: path,
                size: size,
                etag: etag,
                lastModified: lastModified,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $TilesTable,
      Tile,
      $$TilesTableFilterComposer,
      $$TilesTableOrderingComposer,
      $$TilesTableAnnotationComposer,
      $$TilesTableCreateCompanionBuilder,
      $$TilesTableUpdateCompanionBuilder,
      (Tile, BaseReferences<_$AppDb, $TilesTable, Tile>),
      Tile,
      PrefetchHooks Function()
    >;

class $AppDbManager {
  final _$AppDb _db;
  $AppDbManager(this._db);
  $$TilesTableTableManager get tiles =>
      $$TilesTableTableManager(_db, _db.tiles);
}
