//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:lumisovellus_api/src/model/help_event_location_output.dart';
import 'package:json_annotation/json_annotation.dart';

part 'help_event_participation.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HelpEventParticipation {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [HelpEventParticipation] instance.
HelpEventParticipation({
  required  this.acceptanceId,
  required  this.eventId,
  required  this.responderId,
  required  this.location,
  required  this.acceptedAt,
});

      /// Participation entry ID
  @JsonKey(
    
    name: r'acceptanceId',
    required: true,
    includeIfNull: false,
  )


  final String acceptanceId;



      /// Help event ID
  @JsonKey(
    
    name: r'eventId',
    required: true,
    includeIfNull: false,
  )


  final String eventId;



      /// Rescuer user ID
  @JsonKey(
    
    name: r'responderId',
    required: true,
    includeIfNull: false,
  )


  final String responderId;



  @JsonKey(
    
    name: r'location',
    required: true,
    includeIfNull: true,
  )


  final HelpEventLocationOutput? location;



      /// Acceptance timestamp
  @JsonKey(
    
    name: r'acceptedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime acceptedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is HelpEventParticipation &&
      other.acceptanceId == acceptanceId &&
      other.eventId == eventId &&
      other.responderId == responderId &&
      other.location == location &&
      other.acceptedAt == acceptedAt;

    @override
    int get hashCode =>
        acceptanceId.hashCode +
        eventId.hashCode +
        responderId.hashCode +
        (location == null ? 0 : location.hashCode) +
        acceptedAt.hashCode;

  factory HelpEventParticipation.fromJson(Map<String, dynamic> json) => _$HelpEventParticipationFromJson(json);

  Map<String, dynamic> toJson() => _$HelpEventParticipationToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

