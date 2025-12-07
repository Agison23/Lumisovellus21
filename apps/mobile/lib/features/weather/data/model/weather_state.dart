class WeatherState {
  final double? tempMax;
  final double? tempMin;
  final int? daysAboveZero;
  final double? windDirection;
  final double? windAvg;
  final double? windMax;
  final double? snowDepthChange;

  const WeatherState({
    this.tempMax,
    this.tempMin,
    this.daysAboveZero,
    this.windDirection,
    this.windAvg,
    this.windMax,
    this.snowDepthChange
  });
}