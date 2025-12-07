import 'package:lumisovellus_api/lumisovellus_api.dart';
import '../services/auth_service.dart';

class AuthRepository {
  AuthRepository(this._service);

  final AuthService _service;

  Future<AuthResponse> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) {
    return _service.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) {
    return _service.login(
      email: email,
      password: password,
    );
  }

  Future<User> getCurrentUser() {
    return _service.getMe();
  }
}
