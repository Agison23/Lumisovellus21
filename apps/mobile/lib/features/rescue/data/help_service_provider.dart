import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisovellus/core/config/app_config.dart';
import '../model/help_models.dart';
import 'help_service_fake.dart';
import 'help_service_backend.dart';

final inMemoryHelpStoreProvider = Provider<InMemoryHelpStore>((ref) {
  return InMemoryHelpStore();
});

final helpServiceProvider = Provider<HelpService>((ref) {
  final cfg = ref.watch(appConfigProvider);
  if (cfg.useRealBackend) {
    return BackendHelpService(baseUrl: cfg.apiBaseUrl);
  }
  final store = ref.watch(inMemoryHelpStoreProvider);
  return FakeHelpService(store);
});


