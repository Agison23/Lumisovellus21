import 'package:test/test.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';


/// tests for UsersApi
void main() {
  final instance = LumisovellusApi().getUsersApi();

  group(UsersApi, () {
    // Update battery status
    //
    // Update the battery status for a mobile user
    //
    //Future<ApiV1UsersDeviceIdLocationPost200Response> apiV1UsersDeviceIdBatteryPost(String deviceId, BatteryUpdate batteryUpdate) async
    test('test apiV1UsersDeviceIdBatteryPost', () async {
      // TODO
    });

    // Update mobile user location
    //
    // Update or create mobile user location data for tracking and rescue purposes
    //
    //Future<ApiV1UsersDeviceIdLocationPost200Response> apiV1UsersDeviceIdLocationPost(String deviceId, LocationUpdate locationUpdate) async
    test('test apiV1UsersDeviceIdLocationPost', () async {
      // TODO
    });

    // Get user role
    //
    // Retrieve the role and permissions for a mobile user
    //
    //Future<ApiV1UsersDeviceIdRoleGet200Response> apiV1UsersDeviceIdRoleGet(String deviceId) async
    test('test apiV1UsersDeviceIdRoleGet', () async {
      // TODO
    });

    // Update user role
    //
    // Update the role for a mobile user
    //
    //Future<ApiV1UsersDeviceIdRoleGet200Response> apiV1UsersDeviceIdRolePost(String deviceId, RoleUpdate roleUpdate) async
    test('test apiV1UsersDeviceIdRolePost', () async {
      // TODO
    });

    // List all users
    //
    // Get a list of all users (admin only)
    //
    //Future<ApiV1UsersGet200Response> apiV1UsersGet() async
    test('test apiV1UsersGet', () async {
      // TODO
    });

    // Delete a user
    //
    // Delete a user and all related data (admin only)
    //
    //Future<AuthResetPasswordPost200Response> apiV1UsersIdDelete(String id) async
    test('test apiV1UsersIdDelete', () async {
      // TODO
    });

    // Update a user
    //
    // Update user information (admin only)
    //
    //Future<AuthProfileGet200Response> apiV1UsersIdPut(String id, ApiV1UsersIdPutRequest apiV1UsersIdPutRequest) async
    test('test apiV1UsersIdPut', () async {
      // TODO
    });

    // Get current user details
    //
    // Get details of the currently authenticated user
    //
    //Future<AuthProfileGet200Response> apiV1UsersMeGet() async
    test('test apiV1UsersMeGet', () async {
      // TODO
    });

  });
}
