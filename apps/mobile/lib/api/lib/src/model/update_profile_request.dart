//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'update_profile_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UpdateProfileRequest {
  /// Returns a new [UpdateProfileRequest] instance.
  UpdateProfileRequest({

     this.firstName,

     this.lastName,

     this.email,

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



      /// Phone number
  @JsonKey(
    
    name: r'phoneNumber',
    required: false,
    includeIfNull: false,
  )


  final String? phoneNumber;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UpdateProfileRequest &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.email == email &&
      other.phoneNumber == phoneNumber;

    @override
    int get hashCode =>
        firstName.hashCode +
        lastName.hashCode +
        email.hashCode +
        phoneNumber.hashCode;

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) => _$UpdateProfileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

