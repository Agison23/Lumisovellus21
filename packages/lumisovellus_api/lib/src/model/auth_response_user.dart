//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'auth_response_user.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AuthResponseUser {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [AuthResponseUser] instance.
AuthResponseUser({
  required  this.id,
  required  this.firstName,
  required  this.lastName,
  required  this.email,
  required  this.role,
});

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'firstName',
    required: true,
    includeIfNull: false,
  )


  final String firstName;



  @JsonKey(
    
    name: r'lastName',
    required: true,
    includeIfNull: true,
  )


  final String? lastName;



  @JsonKey(
    
    name: r'email',
    required: true,
    includeIfNull: true,
  )


  final String? email;



  @JsonKey(
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final String role;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AuthResponseUser &&
      other.id == id &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.email == email &&
      other.role == role;

    @override
    int get hashCode =>
        id.hashCode +
        firstName.hashCode +
        (lastName == null ? 0 : lastName.hashCode) +
        (email == null ? 0 : email.hashCode) +
        role.hashCode;

  factory AuthResponseUser.fromJson(Map<String, dynamic> json) => _$AuthResponseUserFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseUserToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

