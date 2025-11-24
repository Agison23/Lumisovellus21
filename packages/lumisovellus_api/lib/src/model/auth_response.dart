//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:lumisovellus_api/src/model/auth_response_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AuthResponse {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [AuthResponse] instance.
AuthResponse({
  required  this.user,
  required  this.accessToken,
  required  this.refreshToken,
});

  @JsonKey(
    
    name: r'user',
    required: true,
    includeIfNull: false,
  )


  final AuthResponseUser user;



      /// JWT access token
  @JsonKey(
    
    name: r'accessToken',
    required: true,
    includeIfNull: false,
  )


  final String accessToken;



      /// JWT refresh token
  @JsonKey(
    
    name: r'refreshToken',
    required: true,
    includeIfNull: false,
  )


  final String refreshToken;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AuthResponse &&
      other.user == user &&
      other.accessToken == accessToken &&
      other.refreshToken == refreshToken;

    @override
    int get hashCode =>
        user.hashCode +
        accessToken.hashCode +
        refreshToken.hashCode;

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

