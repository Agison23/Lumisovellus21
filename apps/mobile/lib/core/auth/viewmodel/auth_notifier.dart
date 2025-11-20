import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lumisovellus/core/network/providers.dart';

import '../data/repositories/auth_repository.dart';
import '../data/services/auth_service.dart';
import 'auth_session.dart';

const storage = FlutterSecureStorage();

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(ref.watch(apiClientProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(authServiceProvider)),
);

final authSessionProvider =
    NotifierProvider<AuthSessionNotifier, AuthSession>(() => AuthSessionNotifier());

class AuthSessionNotifier extends Notifier<AuthSession> {
  @override
  AuthSession build() {
    loadSession();
    return const AuthSession();
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final repo = ref.read(authRepositoryProvider);
    final auth = await repo.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );

    final token = auth.accessToken;
    await _applyToken(token);
    final user = await repo.getCurrentUser();

    state = AuthSession(
      accessToken: token,
      refreshToken: auth.refreshToken,
      user: user,
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final repo = ref.read(authRepositoryProvider);
    final auth = await repo.login(email: email, password: password);

    final token = auth.accessToken;
    await _applyToken(token);
    final user = await repo.getCurrentUser();

    state = AuthSession(
      accessToken: token,
      refreshToken: auth.refreshToken,
      user: user,
    );
  }

  Future<void> loadSession() async {
    final token = await storage.read(key: 'authAccessToken');
    if (token == null || token.isEmpty) {
      state = const AuthSession();
      return;
    }

    final repo = ref.read(authRepositoryProvider);

    try {
      await _applyToken(token);
      final user = await repo.getCurrentUser();

      state = AuthSession(
        accessToken: token,
        user: user,
      );
    } catch (_) {
      await logout();
    }
  }

  Future<void> _applyToken(String? token) async {
    if (token == null || token.isEmpty) return;

    await storage.write(key: 'authAccessToken', value: token);

    final apiClient = ref.read(apiClientProvider);
    apiClient.setToken(token);
  }


  Future<void> logout() async {
    await storage.delete(key: 'authAccessToken');
    state = const AuthSession();
  }
}
