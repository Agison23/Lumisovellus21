//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RegisterRequest {
  /// Returns a new [RegisterRequest] instance.
  RegisterRequest({

    required  this.firstName,

     this.lastName,

    required  this.email,

    required  this.password,

     this.role,
  });

      /// User first name
  @JsonKey(
    
    name: r'firstName',
    required: true,
    includeIfNull: false,
  )


  final String firstName;



      /// User last name
  @JsonKey(
    
    name: r'lastName',
    required: false,
    includeIfNull: false,
  )


  final String? lastName;



      /// User email address
  @JsonKey(
    
    name: r'email',
    required: true,
    includeIfNull: false,
  )


  final String email;



      /// User password
  @JsonKey(
    
    name: r'password',
    required: true,
    includeIfNull: false,
  )


  final String password;



      /// User role
  @JsonKey(
    
    name: r'role',
    required: false,
    includeIfNull: false,
  )


  final RegisterRequestRoleEnum? role;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RegisterRequest &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.email == email &&
      other.password == password &&
      other.role == role;

    @override
    int get hashCode =>
        firstName.hashCode +
        lastName.hashCode +
        email.hashCode +
        password.hashCode +
        role.hashCode;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) => _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

/// User role
enum RegisterRequestRoleEnum {
    /// User role
@JsonValue(r'NORMAL')
NORMAL(r'NORMAL'),
    /// User role
@JsonValue(r'ADMIN')
ADMIN(r'ADMIN'),
    /// User role
@JsonValue(r'RESCUE')
RESCUE(r'RESCUE');

const RegisterRequestRoleEnum(this.value);

final String value;

@override
String toString() => value;
}


