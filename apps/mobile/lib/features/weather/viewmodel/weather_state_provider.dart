import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisovellus/core/network/providers.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';
import '../data/services/weather_service.dart';
import '../data/model/weather_state.dart';

final weatherStateProvider = FutureProvider<WeatherState>((ref) async {

  final weatherServiceProvider = Provider<WeatherService>(
    (ref) => WeatherService(ref.watch(apiClientProvider)),
  );

  final weatherService = ref.watch(weatherServiceProvider);

  final WeatherMetric tempMaxMetric;
  final WeatherMetric tempMinMetric;
  final WeatherFilterDaysResponse daysMetric;
  final WeatherMetric windDirectionMetric;
  final WeatherMetric windAvgMetric;
  final WeatherMetric windMaxMetric;
  final WeatherMetric snowDepthMetric;

  tempMaxMetric = await weatherService.fetchMaxTemperature();
  tempMinMetric = await weatherService.fetchMinTemperature();
  daysMetric = await weatherService.fetchDaysAboveZero();
  windDirectionMetric = await weatherService.fetchWindDirection();
  windAvgMetric = await weatherService.fetchWindAverage();
  windMaxMetric = await weatherService.fetchMaxWind();
  //snowDepthMetric = await weatherService.fetchSnowDepthChange();

  final weatherState = WeatherState(
    tempMax: tempMaxMetric.value.toDouble(),
    tempMin: tempMinMetric.value.toDouble(),
    daysAboveZero: daysMetric.matches.length,
    windDirection: windDirectionMetric.value.toDouble(),
    windAvg: windAvgMetric.value.toDouble(),
    windMax: windMaxMetric.value.toDouble(),
    snowDepthChange: -999 //snowDepthMetric.value.toDouble()
  );
  return weatherState;
});

