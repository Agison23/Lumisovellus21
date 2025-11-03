import 'dart:convert';
import 'package:drift/drift.dart';
import '../app_db.dart';

class JobsDao {
  JobsDao(this.db);
  final AppDb db;

  Future<void> enqueue({
    required String kind,
    required Map<String, dynamic> payload,
    String? dedupeKey,
    int priority = 0,
    int delayMs = 0,
    int maxAttempts = 5,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final id = '$kind:${dedupeKey ?? now}';

    await db
        .into(db.jobs)
        .insertOnConflictUpdate(
          JobsCompanion(
            id: Value(id),
            kind: Value(kind),
            payload: Value(jsonEncode(payload)),
            status: const Value('queued'),
            priority: Value(priority),
            attempts: const Value(0),
            maxAttempts: Value(maxAttempts),
            nextRunAt: Value(now + delayMs),
            dedupeKey: Value(dedupeKey),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  Future<Job?> takeDue() async {
    return await db.transaction(() async {
      final now = DateTime.now().millisecondsSinceEpoch;
      final q = db.select(db.jobs)
        ..where(
          (j) =>
              j.status.equals('queued') &
              j.nextRunAt.isSmallerOrEqualValue(now),
        )
        ..orderBy([
          (j) => OrderingTerm(expression: j.priority, mode: OrderingMode.desc),
          (j) => OrderingTerm(expression: j.nextRunAt),
        ])
        ..limit(1);

      final job = await q.getSingleOrNull();

      if (job == null) return null;

      await (db.update(db.jobs)..where((t) => t.id.equals(job.id))).write(
        JobsCompanion(status: const Value('running'), updatedAt: Value(now)),
      );

      return job;
    });
  }

  Future<void> complete(String id) async {
    await (db.delete(db.jobs)..where((j) => j.id.equals(id))).go();
  }

  Future<void> fail(Job job, Duration backoff) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final next = now + backoff.inMilliseconds;
    await (db.update(db.jobs)..where((j) => j.id.equals(job.id))).write(
      JobsCompanion(
        status: const Value('queued'),
        attempts: Value(job.attempts + 1),
        nextRunAt: Value(next),
        updatedAt: Value(now),
      ),
    );
  }
}
