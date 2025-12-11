//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'update_user_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UpdateUserRequest {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [UpdateUserRequest] instance.
UpdateUserRequest({
   this.firstName,
   this.lastName,
   this.email,
   this.role,
   this.phoneNumber,
});

      /// User first name
  @JsonKey(
    
    name: r'firstName',
    required: false,
    includeIfNull: false,
  )


  final String? firstName;



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
    required: false,
    includeIfNull: false,
  )


  final String? email;



      /// User role
  @JsonKey(
    
    name: r'role',
    required: false,
    includeIfNull: false,
  )


  final UpdateUserRequestRoleEnum? role;



      /// Phone number
  @JsonKey(
    
    name: r'phoneNumber',
    required: false,
    includeIfNull: false,
  )


  final String? phoneNumber;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UpdateUserRequest &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.email == email &&
      other.role == role &&
      other.phoneNumber == phoneNumber;

    @override
    int get hashCode =>
        firstName.hashCode +
        lastName.hashCode +
        email.hashCode +
        role.hashCode +
        phoneNumber.hashCode;

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) => _$UpdateUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

/// User role
enum UpdateUserRequestRoleEnum {
    /// User role
@JsonValue(r'NORMAL')
NORMAL(r'NORMAL'),
    /// User role
@JsonValue(r'PREMIUM')
PREMIUM(r'PREMIUM'),
    /// User role
@JsonValue(r'ADMIN')
ADMIN(r'ADMIN'),
    /// User role
@JsonValue(r'RESCUE')
RESCUE(r'RESCUE'),
    /// User role
@JsonValue(r'GUIDE')
GUIDE(r'GUIDE');

const UpdateUserRequestRoleEnum(this.value);

final String value;

@override
String toString() => value;
}


