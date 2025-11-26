//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class User {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [User] instance.
User({
  required  this.id,
  required  this.firstName,
  required  this.lastName,
  required  this.email,
  required  this.role,
   this.phoneNumber,
   this.lowBattery,
   this.createdAt,
  required  this.updatedAt,
   this.devId,
   this.ipAddress,
});

      /// User ID
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



  @JsonKey(
    
    name: r'phoneNumber',
    required: false,
    includeIfNull: false,
  )


  final String? phoneNumber;



  @JsonKey(
    
    name: r'lowBattery',
    required: false,
    includeIfNull: false,
  )


  final num? lowBattery;



      /// Creation timestamp
  @JsonKey(
    
    name: r'createdAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? createdAt;



      /// Last update timestamp
  @JsonKey(
    
    name: r'updatedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime updatedAt;



  @JsonKey(
    
    name: r'devId',
    required: false,
    includeIfNull: false,
  )


  final String? devId;



  @JsonKey(
    
    name: r'ipAddress',
    required: false,
    includeIfNull: false,
  )


  final String? ipAddress;





    @override
    bool operator ==(Object other) => identical(this, other) || other is User &&
      other.id == id &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.email == email &&
      other.role == role &&
      other.phoneNumber == phoneNumber &&
      other.lowBattery == lowBattery &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.devId == devId &&
      other.ipAddress == ipAddress;

    @override
    int get hashCode =>
        id.hashCode +
        firstName.hashCode +
        (lastName == null ? 0 : lastName.hashCode) +
        (email == null ? 0 : email.hashCode) +
        role.hashCode +
        (phoneNumber == null ? 0 : phoneNumber.hashCode) +
        lowBattery.hashCode +
        createdAt.hashCode +
        updatedAt.hashCode +
        (devId == null ? 0 : devId.hashCode) +
        (ipAddress == null ? 0 : ipAddress.hashCode);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

