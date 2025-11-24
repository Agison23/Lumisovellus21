//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'weather_period.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WeatherPeriod {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [WeatherPeriod] instance.
WeatherPeriod({
  required  this.start,
  required  this.end,
});

      /// Start of the look-back window
  @JsonKey(
    
    name: r'start',
    required: true,
    includeIfNull: false,
  )


  final DateTime start;



      /// End of the look-back window (now)
  @JsonKey(
    
    name: r'end',
    required: true,
    includeIfNull: false,
  )


  final DateTime end;





    @override
    bool operator ==(Object other) => identical(this, other) || other is WeatherPeriod &&
      other.start == start &&
      other.end == end;

    @override
    int get hashCode =>
        start.hashCode +
        end.hashCode;

  factory WeatherPeriod.fromJson(Map<String, dynamic> json) => _$WeatherPeriodFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherPeriodToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

