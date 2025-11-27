class WeatherState {
  final double tempMax;
  final double tempMin;
  final int daysAboveZero;
  final double windDirection;
  final double windAvg;
  final double windMax;
  final double snowDepthChange;

  const WeatherState({
    required this.tempMax,
    required this.tempMin,
    required this.daysAboveZero,
    required this.windDirection,
    required this.windAvg,
    required this.windMax,
    required this.snowDepthChange
  });
}