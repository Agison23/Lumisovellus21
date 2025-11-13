//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'location_update.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LocationUpdate {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [LocationUpdate] instance.
LocationUpdate({
  required  this.timestamp,
  required  this.firstName,
   this.lastName,
  required  this.gpsCoord,
   this.phoneNumber,
});

      /// Unix timestamp
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'timestamp',
    required: true,
    includeIfNull: false,
  )


  final int timestamp;



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



      /// GPS coordinates (format: \"lat,lng\")
  @JsonKey(
    
    name: r'gpsCoord',
    required: true,
    includeIfNull: false,
  )


  final String gpsCoord;



      /// Phone number
  @JsonKey(
    
    name: r'phoneNumber',
    required: false,
    includeIfNull: false,
  )


  final String? phoneNumber;





    @override
    bool operator ==(Object other) => identical(this, other) || other is LocationUpdate &&
      other.timestamp == timestamp &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.gpsCoord == gpsCoord &&
      other.phoneNumber == phoneNumber;

    @override
    int get hashCode =>
        timestamp.hashCode +
        firstName.hashCode +
        lastName.hashCode +
        gpsCoord.hashCode +
        phoneNumber.hashCode;

  factory LocationUpdate.fromJson(Map<String, dynamic> json) => _$LocationUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$LocationUpdateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

