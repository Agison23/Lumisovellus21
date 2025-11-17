//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'weather_filter_days_response_matches_inner.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WeatherFilterDaysResponseMatchesInner {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [WeatherFilterDaysResponseMatchesInner] instance.
WeatherFilterDaysResponseMatchesInner({
  required  this.date,
  required  this.averageTemperature,
});

      /// Date in ISO format
  @JsonKey(
    
    name: r'date',
    required: true,
    includeIfNull: false,
  )


  final DateTime date;



      /// Daily average temperature in Celsius
  @JsonKey(
    
    name: r'averageTemperature',
    required: true,
    includeIfNull: false,
  )


  final num averageTemperature;





    @override
    bool operator ==(Object other) => identical(this, other) || other is WeatherFilterDaysResponseMatchesInner &&
      other.date == date &&
      other.averageTemperature == averageTemperature;

    @override
    int get hashCode =>
        date.hashCode +
        averageTemperature.hashCode;

  factory WeatherFilterDaysResponseMatchesInner.fromJson(Map<String, dynamic> json) => _$WeatherFilterDaysResponseMatchesInnerFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherFilterDaysResponseMatchesInnerToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

