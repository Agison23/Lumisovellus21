//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:lumisovellus_api/src/model/auth_verify_token_get200_response_data.dart';
import 'package:lumisovellus_api/src/model/health_get200_response_meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_verify_token_get200_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AuthVerifyTokenGet200Response {
  /// Returns a new [AuthVerifyTokenGet200Response] instance.
  AuthVerifyTokenGet200Response({

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


  final AuthVerifyTokenGet200ResponseData data;



  @JsonKey(
    
    name: r'meta',
    required: true,
    includeIfNull: false,
  )


  final HealthGet200ResponseMeta meta;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AuthVerifyTokenGet200Response &&
      other.success == success &&
      other.data == data &&
      other.meta == meta;

    @override
    int get hashCode =>
        success.hashCode +
        data.hashCode +
        meta.hashCode;

  factory AuthVerifyTokenGet200Response.fromJson(Map<String, dynamic> json) => _$AuthVerifyTokenGet200ResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthVerifyTokenGet200ResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

