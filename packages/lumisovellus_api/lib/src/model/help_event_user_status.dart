//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:lumisovellus_api/src/model/help_event_location_output.dart';
import 'package:json_annotation/json_annotation.dart';

part 'help_event_user_status.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HelpEventUserStatus {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [HelpEventUserStatus] instance.
HelpEventUserStatus({
  required  this.location,
  required  this.batteryLevel,
});

  @JsonKey(
    
    name: r'location',
    required: true,
    includeIfNull: false,
  )


  final HelpEventLocationOutput location;



      /// Battery level percentage
          // minimum: 0
          // maximum: 100
  @JsonKey(
    
    name: r'batteryLevel',
    required: true,
    includeIfNull: true,
  )


  final int? batteryLevel;





    @override
    bool operator ==(Object other) => identical(this, other) || other is HelpEventUserStatus &&
      other.location == location &&
      other.batteryLevel == batteryLevel;

    @override
    int get hashCode =>
        location.hashCode +
        (batteryLevel == null ? 0 : batteryLevel.hashCode);

  factory HelpEventUserStatus.fromJson(Map<String, dynamic> json) => _$HelpEventUserStatusFromJson(json);

  Map<String, dynamic> toJson() => _$HelpEventUserStatusToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

