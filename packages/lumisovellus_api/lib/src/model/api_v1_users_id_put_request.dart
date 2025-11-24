//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'api_v1_users_id_put_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ApiV1UsersIdPutRequest {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [ApiV1UsersIdPutRequest] instance.
ApiV1UsersIdPutRequest({
   this.firstName,
   this.lastName,
   this.email,
   this.phoneNumber,
   this.role,
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



      /// Phone number
  @JsonKey(
    
    name: r'phoneNumber',
    required: false,
    includeIfNull: false,
  )


  final String? phoneNumber;



  @JsonKey(
    
    name: r'role',
    required: false,
    includeIfNull: false,
  )


  final String? role;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ApiV1UsersIdPutRequest &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.email == email &&
      other.phoneNumber == phoneNumber &&
      other.role == role;

    @override
    int get hashCode =>
        firstName.hashCode +
        lastName.hashCode +
        email.hashCode +
        phoneNumber.hashCode +
        role.hashCode;

  factory ApiV1UsersIdPutRequest.fromJson(Map<String, dynamic> json) => _$ApiV1UsersIdPutRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ApiV1UsersIdPutRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

