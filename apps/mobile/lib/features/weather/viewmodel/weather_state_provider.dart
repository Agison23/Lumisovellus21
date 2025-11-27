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

  final WeatherMetric tempMaxMetric = await weatherService.fetchMaxTemperature();

  final weatherState = WeatherState(
    tempMax: tempMaxMetric.value.toDouble(),
    tempMin: 0.0,
    daysAboveZero: 0,
    windDirection: 0.0,
    windAvg: 0.0,
    windMax: 0.0,
    snowDepthChange: 0.0,
  );
  return weatherState;
});

