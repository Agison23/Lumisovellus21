import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:lumisovellus/core/network/connectivity_provider.dart';
import '../data/services/tile_proxy_server.dart';
import '../data/repositories/map_style_repository.dart';
import '../data/repositories/tile_cache_repository.dart';
import 'package:lumisovellus/core/data/providers.dart';

final tileCacheRepoProvider = Provider((ref) => TileCacheRepository(ref.watch(appDbProvider), ref.watch(jobsDaoProvider)));

final _proxyBaseProvider = FutureProvider<Uri>((ref) async {
  final repo = ref.watch(tileCacheRepoProvider);
  final s = TileProxyServer(
    repo,
    osmBase: Uri.parse('https://a.tile.openstreetmap.org/'),
    demBase: Uri.parse('https://s3.amazonaws.com/elevation-tiles-prod/terrarium/'),
  );
  ref.onDispose(() => s.stop());
  return s.start();
});

final _fileBaseProvider = FutureProvider<Uri>((ref) async {
  final d = await getApplicationDocumentsDirectory();
  final dir = Directory(p.join(d.path, 'tiles'));
  if (!await dir.exists()) await dir.create(recursive: true);
  return Uri.parse('file://${dir.path}/');
});

final styleBaseProvider = FutureProvider<Uri>((ref) async {
  // await ref.read(tileCacheRepoProvider).clearAll();
  final online = ref.watch(connectivityProvider);
  if (online) return await ref.watch(_proxyBaseProvider.future);
  return await ref.watch(_fileBaseProvider.future);
});

class MapStyleNotifier extends AutoDisposeAsyncNotifier<String> {
  @override
  Future<String> build() async {
    final base = await ref.watch(styleBaseProvider.future);
    return MapStyleRepository().build(base: base);
  }
}

final mapStyleNotifierProvider =
    AutoDisposeAsyncNotifierProvider<MapStyleNotifier, String>(MapStyleNotifier.new);
