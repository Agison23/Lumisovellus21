import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisovellus/core/config/app_config.dart';
import 'package:lumisovellus/core/network/providers.dart';
import 'data/services/help_service.dart';
import 'data/services/help_service_fake.dart';
import 'data/services/help_service_backend.dart';
import 'data/repositories/help_repository_impl.dart';
import 'domain/repositories/help_repository.dart';
import 'domain/use_cases/request_help_use_case.dart';
import 'domain/use_cases/cancel_help_use_case.dart';

// Service layer providers
final _inMemoryHelpStoreProvider = Provider<InMemoryHelpStore>((ref) {
  return InMemoryHelpStore();
});

final _helpServiceProvider = Provider<HelpService>((ref) {
  final cfg = ref.watch(appConfigProvider);
  if (cfg.useRealBackend) {
    final apiClient = ref.watch(apiClientProvider);
    return BackendHelpService(apiClient: apiClient);
  }
  final store = ref.watch(_inMemoryHelpStoreProvider);
  return FakeHelpService(store);
});

// Repository layer providers
final helpRepositoryProvider = Provider<HelpRepository>((ref) {
  final service = ref.watch(_helpServiceProvider);
  return HelpRepositoryImpl(service);
});

// Use case providers
final requestHelpUseCaseProvider = Provider<RequestHelpUseCase>((ref) {
  final repository = ref.watch(helpRepositoryProvider);
  return RequestHelpUseCase(repository);
});

final cancelHelpUseCaseProvider = Provider<CancelHelpUseCase>((ref) {
  final repository = ref.watch(helpRepositoryProvider);
  return CancelHelpUseCase(repository);
});
