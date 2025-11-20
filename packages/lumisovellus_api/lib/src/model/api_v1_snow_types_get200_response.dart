//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:lumisovellus_api/src/model/snow_type.dart';
import 'package:lumisovellus_api/src/model/health_get200_response_meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_v1_snow_types_get200_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ApiV1SnowTypesGet200Response {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [ApiV1SnowTypesGet200Response] instance.
ApiV1SnowTypesGet200Response({
  required  this.success,
  this.data = const [],
  required  this.meta,
});

      /// Indicates if the request was successful
  @JsonKey(
    
    name: r'success',
    required: true,
    includeIfNull: false,
  )


  final bool success;



      /// List of snow types
  @JsonKey(
    
    name: r'data',
    required: true,
    includeIfNull: false,
  )


  final List<SnowType> data;



  @JsonKey(
    
    name: r'meta',
    required: true,
    includeIfNull: false,
  )


  final HealthGet200ResponseMeta meta;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ApiV1SnowTypesGet200Response &&
      other.success == success &&
      other.data == data &&
      other.meta == meta;

    @override
    int get hashCode =>
        success.hashCode +
        data.hashCode +
        meta.hashCode;

  factory ApiV1SnowTypesGet200Response.fromJson(Map<String, dynamic> json) => _$ApiV1SnowTypesGet200ResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiV1SnowTypesGet200ResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

