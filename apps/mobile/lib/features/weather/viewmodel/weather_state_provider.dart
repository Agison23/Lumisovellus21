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

  WeatherMetric? tempMaxMetric;
  WeatherMetric? tempMinMetric;
  WeatherFilterDaysResponse? daysMetric;
  WeatherMetric? windDirectionMetric;
  WeatherMetric? windAvgMetric;
  WeatherMetric? windMaxMetric;
  WeatherMetric? snowDepthMetric;

  try {
    tempMaxMetric = await weatherService.fetchMaxTemperature();
  } on Exception {
    tempMaxMetric = null;
  }

  try {
    tempMinMetric = await weatherService.fetchMinTemperature();
  } on Exception {
    tempMinMetric = null;
  }

  try{
    daysMetric = await weatherService.fetchDaysAboveZero();
  } on Exception {
    daysMetric = null;
  }

  try {
    windDirectionMetric = await weatherService.fetchWindDirection();
  } on Exception {
    windDirectionMetric = null;
  }

  try {
    windAvgMetric = await weatherService.fetchWindAverage();
  } on Exception {
    windAvgMetric = null;
  }

  try {
    windMaxMetric = await weatherService.fetchMaxWind();
  } on Exception {
    windMaxMetric = null;
  }

  try {
    snowDepthMetric = await weatherService.fetchSnowDepthChange();
  } on Exception {
    snowDepthMetric = null;
  }

  final weatherState = WeatherState(
    tempMax: tempMaxMetric?.value.toDouble(),
    tempMin: tempMinMetric?.value.toDouble(),
    daysAboveZero: daysMetric?.matches.length,
    windDirection: windDirectionMetric?.value.toDouble(),
    windAvg: windAvgMetric?.value.toDouble(),
    windMax: windMaxMetric?.value.toDouble(),
    snowDepthChange: snowDepthMetric?.value.toDouble()
  );
  return weatherState;
});

