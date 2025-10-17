import 'dart:convert';
import 'dart:io';
import '../persistence/app_db.dart';
import '../persistence/daos/jobs_dao.dart';

class JobRunner {
  JobRunner(this.db, this.jobs);
  final AppDb db;
  final JobsDao jobs;
  final _handlers = <String, Future<bool> Function(Job)>{};

  void register(String kind, Future<bool> Function(Job) fn) {
    _handlers[kind] = fn;
  }

  Future<void> runOnce({int batch = 32}) async {
    var n = 0;
    while (n < batch) {
      final job = await jobs.takeDue();
      if (job == null) break;
      final handler = _handlers[job.kind];
      final ok = handler == null ? true : await handler(job);
      if (ok) {
        await jobs.complete(job.id);
      } else {
        final d = Duration(milliseconds: 500 * (1 << job.attempts));
        final cap = d > const Duration(minutes: 10) ? const Duration(minutes: 10) : d;
        await jobs.fail(job, cap);
      }
      n++;
    }
  }
}

Future<bool> handleTileMeta(Job job, AppDb db) async {
  final m = jsonDecode(job.payload) as Map<String, dynamic>;
  final f = File(m['path'] as String);

  if (!await f.exists()) return true;

  await db.upsertTileMeta(
    source: m['source'] as String,
    z: m['z'] as int,
    x: m['x'] as int,
    y: m['y'] as int,
    path: f.path,
    size: await f.length(),
    etag: m['etag'] as String?,
    lastModified: (m['lastModified'] as int?) == null ? null : DateTime.fromMillisecondsSinceEpoch(m['lastModified'] as int, isUtc: true),
    expiresAt: (m['expiresAt'] as int?) == null ? null : DateTime.fromMillisecondsSinceEpoch(m['expiresAt'] as int, isUtc: true),
  );
  return true;
}
