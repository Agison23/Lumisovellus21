import 'package:lumisovellus/core/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';

class AuthService {
  AuthService(this.api);

  final ApiClient api;

  Future<AuthResponse> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final body = RegisterRequest(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );

    final Response<AuthRegisterPost201Response> res = await api.auth
        .authRegisterPost(
          registerRequest: body
        );
    return res.data!.data;
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final body = LoginRequest(
      email: email,
      password: password,
    );

    final res = await api.auth.authLoginPost(loginRequest: body);
    return res.data!.data;
  }

  Future<User> getMe() async {
    final res = await api.users.apiV1UsersMeGet();
    final body = res.data;

    if (body == null || !body.success) {
      throw Exception('Failed to fetch current user');
    }

    return body.data;
  }
}
