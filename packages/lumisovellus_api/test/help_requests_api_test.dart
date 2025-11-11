import 'package:test/test.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';


/// tests for HelpRequestsApi
void main() {
  final instance = LumisovellusApi().getHelpRequestsApi();

  group(HelpRequestsApi, () {
    // Get help requests
    //
    // Retrieve all help requests for rescue interface
    //
    //Future<ApiV1SnowTypesGet200Response> apiV1HelpRequestsGet() async
    test('test apiV1HelpRequestsGet', () async {
      // TODO
    });

    // Get users who can help with a specific help request
    //
    // Retrieve all users who have been notified about a help request with their status and distance
    //
    //Future<ApiV1HelpRequestsIdHelpersGet200Response> apiV1HelpRequestsIdHelpersGet(String id) async
    test('test apiV1HelpRequestsIdHelpersGet', () async {
      // TODO
    });

    // Create help request
    //
    // Create a help request for emergency or assistance
    //
    //Future<ApiV1HelpRequestsPost200Response> apiV1HelpRequestsPost(HelpRequest helpRequest) async
    test('test apiV1HelpRequestsPost', () async {
      // TODO
    });

    // Update help response
    //
    // Update the response status for a help request
    //
    //Future<ApiV1UsersDeviceIdLocationPost200Response> apiV1HelpResponsesPost(HelpResponse helpResponse) async
    test('test apiV1HelpResponsesPost', () async {
      // TODO
    });

  });
}
