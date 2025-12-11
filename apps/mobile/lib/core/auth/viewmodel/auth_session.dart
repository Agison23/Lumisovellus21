import 'package:lumisovellus_api/lumisovellus_api.dart';

class AuthSession {
  final String? accessToken;
  final String? refreshToken;
  final User? user;

  const AuthSession({
    this.accessToken,
    this.refreshToken,
    this.user,
  });

  bool get isLoggedIn => accessToken != null;
}
