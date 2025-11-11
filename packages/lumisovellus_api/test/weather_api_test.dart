import 'package:test/test.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';


/// tests for WeatherApi
void main() {
  final instance = LumisovellusApi().getWeatherApi();

  group(WeatherApi, () {
    // Get latest weather data
    //
    // Returns the most recent weather data from the FMI API
    //
    //Future<ApiV1SnowTypesPost201Response> weatherGet() async
    test('test weatherGet', () async {
      // TODO
    });

    // Get weather history
    //
    // Returns historical weather data
    //
    //Future<ApiV1SnowTypesGet200Response> weatherHistoryGet({ String limit }) async
    test('test weatherHistoryGet', () async {
      // TODO
    });

    // Manually trigger weather update
    //
    // Fetches new weather data from FMI API and saves it to database
    //
    //Future<ApiV1SnowTypesPost201Response> weatherUpdatePost() async
    test('test weatherUpdatePost', () async {
      // TODO
    });

  });
}
