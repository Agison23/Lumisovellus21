import 'package:test/test.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';


/// tests for HealthApi
void main() {
  final instance = LumisovellusApi().getHealthApi();

  group(HealthApi, () {
    // Health check endpoint
    //
    // Returns the current status of the API server
    //
    //Future<HealthGet200Response> healthGet() async
    test('test healthGet', () async {
      // TODO
    });

  });
}
