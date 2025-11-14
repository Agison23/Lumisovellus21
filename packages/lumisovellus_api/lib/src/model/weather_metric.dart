//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:lumisovellus_api/src/model/weather_location.dart';
import 'package:lumisovellus_api/src/model/weather_period.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather_metric.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WeatherMetric {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [WeatherMetric] instance.
WeatherMetric({
  required  this.type,
  required  this.item,
  required  this.value,
  required  this.unit,
  required  this.days,
  required  this.period,
  required  this.location,
});

      /// Metric type
  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final WeatherMetricTypeEnum type;



      /// Weather item
  @JsonKey(
    
    name: r'item',
    required: true,
    includeIfNull: false,
  )


  final String item;



      /// Calculated value for the metric
  @JsonKey(
    
    name: r'value',
    required: true,
    includeIfNull: false,
  )


  final num value;



      /// Unit of measurement
  @JsonKey(
    
    name: r'unit',
    required: true,
    includeIfNull: false,
  )


  final String unit;



      /// Number of days included in the window
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





    @override
    bool operator ==(Object other) => identical(this, other) || other is WeatherMetric &&
      other.type == type &&
      other.item == item &&
      other.value == value &&
      other.unit == unit &&
      other.days == days &&
      other.period == period &&
      other.location == location;

    @override
    int get hashCode =>
        type.hashCode +
        item.hashCode +
        value.hashCode +
        unit.hashCode +
        days.hashCode +
        period.hashCode +
        location.hashCode;

  factory WeatherMetric.fromJson(Map<String, dynamic> json) => _$WeatherMetricFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherMetricToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

/// Metric type
enum WeatherMetricTypeEnum {
    /// Metric type
@JsonValue(r'average')
average(r'average'),
    /// Metric type
@JsonValue(r'minimum')
minimum(r'minimum'),
    /// Metric type
@JsonValue(r'maximum')
maximum(r'maximum'),
    /// Metric type
@JsonValue(r'change')
change(r'change');

const WeatherMetricTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


