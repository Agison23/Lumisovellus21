//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:lumisovellus_api/src/model/weather_location.dart';
import 'package:lumisovellus_api/src/model/weather_filter_days_response_matches_inner.dart';
import 'package:lumisovellus_api/src/model/weather_period.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather_filter_days_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WeatherFilterDaysResponse {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [WeatherFilterDaysResponse] instance.
WeatherFilterDaysResponse({
  required  this.item,
  required  this.threshold,
  required  this.days,
  required  this.period,
  required  this.location,
  this.matches = const [],
});

      /// Weather item used for filtering
  @JsonKey(
    
    name: r'item',
    required: true,
    includeIfNull: false,
  )


  final WeatherFilterDaysResponseItemEnum item;



      /// Threshold for the average temperature
  @JsonKey(
    
    name: r'threshold',
    required: true,
    includeIfNull: false,
  )


  final num threshold;



      /// Number of days inspected
          // minimum: -9007199254740991
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'days',
    required: true,
    includeIfNull: false,
  )


  final int days;



  @JsonKey(
    
    name: r'period',
    required: true,
    includeIfNull: false,
  )


  final WeatherPeriod period;



  @JsonKey(
    
    name: r'location',
    required: true,
    includeIfNull: false,
  )


  final WeatherLocation location;



      /// Dates matching the filter
  @JsonKey(
    
    name: r'matches',
    required: true,
    includeIfNull: false,
  )


  final List<WeatherFilterDaysResponseMatchesInner> matches;





    @override
    bool operator ==(Object other) => identical(this, other) || other is WeatherFilterDaysResponse &&
      other.item == item &&
      other.threshold == threshold &&
      other.days == days &&
      other.period == period &&
      other.location == location &&
      other.matches == matches;

    @override
    int get hashCode =>
        item.hashCode +
        threshold.hashCode +
        days.hashCode +
        period.hashCode +
        location.hashCode +
        matches.hashCode;

  factory WeatherFilterDaysResponse.fromJson(Map<String, dynamic> json) => _$WeatherFilterDaysResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherFilterDaysResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

/// Weather item used for filtering
enum WeatherFilterDaysResponseItemEnum {
    /// Weather item used for filtering
@JsonValue(r'temperature')
temperature(r'temperature');

const WeatherFilterDaysResponseItemEnum(this.value);

final String value;

@override
String toString() => value;
}


