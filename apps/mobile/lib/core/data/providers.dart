import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/persistence/app_db.dart';
import '../data/persistence/daos/jobs_dao.dart';
import '../data/services/jobs_runner.dart';

final appDbProvider = Provider<AppDb>((ref) => AppDb());

final jobsDaoProvider = Provider<JobsDao>(
  (ref) => JobsDao(ref.read(appDbProvider)),
);

final jobRunnerProvider = Provider<JobRunner>((ref) {
  final db = ref.read(appDbProvider);
  final dao = ref.read(jobsDaoProvider);
  final r = JobRunner(db, dao);
  r.register('tile.meta', (j) => handleTileMeta(j, db));
  return r;
});
