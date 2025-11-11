import 'package:test/test.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';


/// tests for SnowTypesApi
void main() {
  final instance = LumisovellusApi().getSnowTypesApi();

  group(SnowTypesApi, () {
    // Get all snow types
    //
    // Retrieve all available snow types for reviews
    //
    //Future<ApiV1SnowTypesGet200Response> apiV1SnowTypesGet() async
    test('test apiV1SnowTypesGet', () async {
      // TODO
    });

    // Add secondary snow types to a snow type
    //
    // Associate one or more existing snow types as secondary types for the specified snow type. All entities are SnowTypes - \"secondary\" refers only to the relationship. Requires authentication and admin role.
    //
    //Future<ApiV1SnowTypesPost201Response> apiV1SnowTypesIdSecondaryPost(String id, AddSecondarySnowTypesRequest addSecondarySnowTypesRequest) async
    test('test apiV1SnowTypesIdSecondaryPost', () async {
      // TODO
    });

    // Create a new snow type
    //
    // Create a new snow type with the provided information. Requires authentication and admin role.
    //
    //Future<ApiV1SnowTypesPost201Response> apiV1SnowTypesPost(CreateSnowTypeRequest createSnowTypeRequest) async
    test('test apiV1SnowTypesPost', () async {
      // TODO
    });

  });
}
