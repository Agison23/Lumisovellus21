import 'package:lumisovellus/core/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';

class WeatherService {
  final ApiClient api;

  WeatherService(this.api);

  Future<WeatherMetric> fetchMaxTemperature() async {
    final Response<WeatherAverageGet200Response> res = await api.weather.weatherMaximumGet(item: "temperature", days: 3);
    final body = res.data;
    if (body == null || body.success != true) {
      throw Exception('Failed to load weather data');
    }
    return body.data;
  }

  Future<WeatherMetric> fetchMinTemperature() async {
    final Response<WeatherAverageGet200Response> res = await api.weather.weatherMinimumGet(item: "temperature", days: 3);
    final body = res.data;
    if (body == null || body.success != true) {
      throw Exception('Failed to load weather data');
    }
    return body.data;
  }

  Future<WeatherFilterDaysResponse> fetchDaysAboveZero() async {
    final Response<WeatherFilterDaysGet200Response> res = await api.weather.weatherFilterDaysGet(item: "temperature", threshold: 0.0);
    final body = res.data;
    if (body == null || body.success != true) {
      throw Exception('Failed to load weather data');
    }
    return body.data;
  }

  Future<WeatherMetric> fetchWindDirection() async {
    final Response<WeatherAverageGet200Response> res = await api.weather.weatherAverageGet(item: "windDirection");
    final body = res.data;
    if (body == null || body.success != true) {
      throw Exception('Failed to load weather data');
    }
    return body.data;
  }

  Future<WeatherMetric> fetchWindAverage() async {
    final Response<WeatherAverageGet200Response> res = await api.weather.weatherAverageGet(item: "windSpeed");
    final body = res.data;
    if (body == null || body.success != true) {
      throw Exception('Failed to load weather data');
    }
    return body.data;
  }

  Future<WeatherMetric> fetchMaxWind() async {
    final Response<WeatherAverageGet200Response> res = await api.weather.weatherMaximumGet(item: "windSpeed");
    final body = res.data;
    if (body == null || body.success != true) {
      throw Exception('Failed to load weather data');
    }
    return body.data;
  }

  Future<WeatherMetric> fetchSnowDepthChange() async {
    try {
      final Response<WeatherAverageGet200Response> res = await api.weather.weatherChangeGet(item: "snowDepth");
      final body = res.data;
      if (body == null || body.success != true) {
        throw Exception('Failed to load weather data');
      }
      return body.data;
    } on DioException {
        throw Exception('Failed to load weather data');
    }
  }
}
