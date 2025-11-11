import 'package:test/test.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';


/// tests for AuthenticationApi
void main() {
  final instance = LumisovellusApi().getAuthenticationApi();

  group(AuthenticationApi, () {
    // Change user password
    //
    // Change the authenticated user's password
    //
    //Future<AuthResetPasswordPost200Response> authChangePasswordPut(ChangePasswordRequest changePasswordRequest) async
    test('test authChangePasswordPut', () async {
      // TODO
    });

    // Login user
    //
    // Authenticate user with email and password
    //
    //Future<AuthRegisterPost201Response> authLoginPost(LoginRequest loginRequest) async
    test('test authLoginPost', () async {
      // TODO
    });

    // Logout user
    //
    // Logout the authenticated user
    //
    //Future<AuthResetPasswordPost200Response> authLogoutPost() async
    test('test authLogoutPost', () async {
      // TODO
    });

    // Get user profile
    //
    // Retrieve the authenticated user's profile information
    //
    //Future<AuthProfileGet200Response> authProfileGet() async
    test('test authProfileGet', () async {
      // TODO
    });

    // Update user profile
    //
    // Update the authenticated user's profile information
    //
    //Future<AuthProfileGet200Response> authProfilePut(UpdateProfileRequest updateProfileRequest) async
    test('test authProfilePut', () async {
      // TODO
    });

    // Refresh access token
    //
    // Get new access token using refresh token
    //
    //Future<AuthRegisterPost201Response> authRefreshTokenPost(RefreshTokenRequest refreshTokenRequest) async
    test('test authRefreshTokenPost', () async {
      // TODO
    });

    // Register a new user
    //
    // Create a new user account with email and password
    //
    //Future<AuthRegisterPost201Response> authRegisterPost(RegisterRequest registerRequest) async
    test('test authRegisterPost', () async {
      // TODO
    });

    // Request password reset
    //
    // Send password reset email to user
    //
    //Future<AuthResetPasswordPost200Response> authResetPasswordPost(ResetPasswordRequest resetPasswordRequest) async
    test('test authResetPasswordPost', () async {
      // TODO
    });

    // Verify token validity
    //
    // Verify if the provided token is valid and return user information
    //
    //Future<AuthVerifyTokenGet200Response> authVerifyTokenGet() async
    test('test authVerifyTokenGet', () async {
      // TODO
    });

  });
}
