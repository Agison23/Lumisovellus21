//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:lumisovellus_api/src/model/user.dart';
import 'package:lumisovellus_api/src/model/auth_reset_password_post200_response_meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_profile_get200_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AuthProfileGet200Response {
  /// Returns a new [AuthProfileGet200Response] instance.
  AuthProfileGet200Response({

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


  final User data;



  @JsonKey(
    
    name: r'meta',
    required: true,
    includeIfNull: false,
  )


  final AuthResetPasswordPost200ResponseMeta meta;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AuthProfileGet200Response &&
      other.success == success &&
      other.data == data &&
      other.meta == meta;

    @override
    int get hashCode =>
        success.hashCode +
        data.hashCode +
        meta.hashCode;

  factory AuthProfileGet200Response.fromJson(Map<String, dynamic> json) => _$AuthProfileGet200ResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthProfileGet200ResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

