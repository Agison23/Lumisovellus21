//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:lumisovellus_api/src/model/weather_metric.dart';
import 'package:lumisovellus_api/src/model/health_get200_response_meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather_average_get200_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WeatherAverageGet200Response {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [WeatherAverageGet200Response] instance.
WeatherAverageGet200Response({
  required  this.success,
  required  this.data,
  required  this.meta,
});

      /// Indicates if the request was successful
  @JsonKey(
    
    name: r'success',
    required: true,
    includeIfNull: false,
  )


  final bool success;



  @JsonKey(
    
    name: r'data',
    required: true,
    includeIfNull: false,
  )


  final WeatherMetric data;



  @JsonKey(
    
    name: r'meta',
    required: true,
    includeIfNull: false,
  )


  final HealthGet200ResponseMeta meta;





    @override
    bool operator ==(Object other) => identical(this, other) || other is WeatherAverageGet200Response &&
      other.success == success &&
      other.data == data &&
      other.meta == meta;

    @override
    int get hashCode =>
        success.hashCode +
        data.hashCode +
        meta.hashCode;

  factory WeatherAverageGet200Response.fromJson(Map<String, dynamic> json) => _$WeatherAverageGet200ResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherAverageGet200ResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

