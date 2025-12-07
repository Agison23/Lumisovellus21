//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'help_event_location.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HelpEventLocation {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [HelpEventLocation] instance.
HelpEventLocation({
  required  this.latitude,
  required  this.longitude,
   this.accuracy,
});

      /// Latitude
          // minimum: -90
          // maximum: 90
  @JsonKey(
    
    name: r'latitude',
    required: true,
    includeIfNull: false,
  )


  final num latitude;



      /// Longitude
          // minimum: -180
          // maximum: 180
  @JsonKey(
    
    name: r'longitude',
    required: true,
    includeIfNull: false,
  )


  final num longitude;



      /// Location accuracy in meters
          // minimum: 0
  @JsonKey(
    
    name: r'accuracy',
    required: false,
    includeIfNull: false,
  )


  final num? accuracy;





    @override
    bool operator ==(Object other) => identical(this, other) || other is HelpEventLocation &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.accuracy == accuracy;

    @override
    int get hashCode =>
        latitude.hashCode +
        longitude.hashCode +
        (accuracy == null ? 0 : accuracy.hashCode);

  factory HelpEventLocation.fromJson(Map<String, dynamic> json) => _$HelpEventLocationFromJson(json);

  Map<String, dynamic> toJson() => _$HelpEventLocationToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

