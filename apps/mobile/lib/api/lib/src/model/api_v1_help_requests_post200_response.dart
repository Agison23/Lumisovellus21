//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:lumisovellus_api/src/model/api_v1_help_requests_post200_response_data.dart';
import 'package:lumisovellus_api/src/model/auth_reset_password_post200_response_meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_v1_help_requests_post200_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ApiV1HelpRequestsPost200Response {
  /// Returns a new [ApiV1HelpRequestsPost200Response] instance.
  ApiV1HelpRequestsPost200Response({

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


  final ApiV1HelpRequestsPost200ResponseData data;



  @JsonKey(
    
    name: r'meta',
    required: true,
    includeIfNull: false,
  )


  final AuthResetPasswordPost200ResponseMeta meta;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ApiV1HelpRequestsPost200Response &&
      other.success == success &&
      other.data == data &&
      other.meta == meta;

    @override
    int get hashCode =>
        success.hashCode +
        data.hashCode +
        meta.hashCode;

  factory ApiV1HelpRequestsPost200Response.fromJson(Map<String, dynamic> json) => _$ApiV1HelpRequestsPost200ResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiV1HelpRequestsPost200ResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

