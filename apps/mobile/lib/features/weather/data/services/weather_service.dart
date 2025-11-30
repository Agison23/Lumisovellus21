import 'package:lumisovellus/core/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';

class WeatherService {
  final ApiClient api;

  WeatherService(this.api);

  Future<WeatherMetric> fetchMaxTemperature() async {
    final Response<WeatherAverageGet200Response> res = await api.weather.weatherMaximumGet(item: "temperature");

    final body = res.data;
    if (body == null || body.success != true) {
      throw Exception('Failed to load weather data');
    }

    return body.data;
  }
}
