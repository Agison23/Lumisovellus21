//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'auth_verify_token_get200_response_data_user.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AuthVerifyTokenGet200ResponseDataUser {
  /// Returns a new [AuthVerifyTokenGet200ResponseDataUser] instance.
  AuthVerifyTokenGet200ResponseDataUser({

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
    bool operator ==(Object other) => identical(this, other) || other is AuthVerifyTokenGet200ResponseDataUser &&
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

  factory AuthVerifyTokenGet200ResponseDataUser.fromJson(Map<String, dynamic> json) => _$AuthVerifyTokenGet200ResponseDataUserFromJson(json);

  Map<String, dynamic> toJson() => _$AuthVerifyTokenGet200ResponseDataUserToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

