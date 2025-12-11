import 'package:test/test.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';


/// tests for WeatherApi
void main() {
  final instance = LumisovellusApi().getWeatherApi();

  group(WeatherApi, () {
    // Average weather metric
    //
    // Returns the average for supported weather items within the requested period.
    //
    //Future<WeatherAverageGet200Response> weatherAverageGet(String item, { int days }) async
    test('test weatherAverageGet', () async {
      // TODO
    });

    // Snow depth change
    //
    // Returns the change in snow depth between the start and end of the requested period.
    //
    //Future<WeatherAverageGet200Response> weatherChangeGet(String item, { int days }) async
    test('test weatherChangeGet', () async {
      // TODO
    });

    // Filter days with average temperature above threshold
    //
    // Returns the dates within the requested period where the daily average temperature exceeded the threshold.
    //
    //Future<WeatherFilterDaysGet200Response> weatherFilterDaysGet(String item, num threshold, { int days }) async
    test('test weatherFilterDaysGet', () async {
      // TODO
    });

    // Maximum weather metric
    //
    // Returns the maximum temperature or wind speed within the requested period.
    //
    //Future<WeatherAverageGet200Response> weatherMaximumGet(String item, { int days }) async
    test('test weatherMaximumGet', () async {
      // TODO
    });

    // Minimum temperature
    //
    // Returns the minimum temperature within the requested period.
    //
    //Future<WeatherAverageGet200Response> weatherMinimumGet(String item, { int days }) async
    test('test weatherMinimumGet', () async {
      // TODO
    });

  });
}
