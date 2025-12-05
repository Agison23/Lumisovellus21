import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisovellus/core/network/providers.dart';
import 'data/services/help_service.dart';
import 'data/services/help_service_stub.dart';
import 'data/services/help_service_backend.dart';
import 'data/repositories/help_repository_impl.dart';
import 'domain/repositories/help_repository.dart';
import 'domain/use_cases/request_help_use_case.dart';
import 'domain/use_cases/cancel_help_use_case.dart';
import 'domain/use_cases/complete_help_use_case.dart';

// Service layer providers
final _inMemoryHelpStoreProvider = Provider<InMemoryHelpStore>((ref) {
  return InMemoryHelpStore();
});

final _helpServiceProvider = Provider<HelpService>((ref) {
  // Check build-time flag to determine if we should use stub backend
  // By default, always use real backend unless USE_STUB_BACKEND is set to true
  const useStubBackend = bool.fromEnvironment('USE_STUB_BACKEND', defaultValue: false);
  
  if (useStubBackend) {
    final store = ref.watch(_inMemoryHelpStoreProvider);
    return StubHelpService(store);
  }
  
  final apiClient = ref.watch(apiClientProvider);
  return BackendHelpService(apiClient: apiClient);
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

final completeHelpUseCaseProvider = Provider<CompleteHelpUseCase>((ref) {
  final repository = ref.watch(helpRepositoryProvider);
  return CompleteHelpUseCase(repository);
});
