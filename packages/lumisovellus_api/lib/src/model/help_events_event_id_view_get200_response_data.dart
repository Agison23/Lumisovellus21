//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:lumisovellus_api/src/model/help_event_rescuee.dart';
import 'package:lumisovellus_api/src/model/help_event_location_output.dart';
import 'package:lumisovellus_api/src/model/help_event_rescuee_view.dart';
import 'package:lumisovellus_api/src/model/help_event_participation.dart';
import 'package:lumisovellus_api/src/model/help_event_rescuer_view.dart';
import 'package:json_annotation/json_annotation.dart';

part 'help_events_event_id_view_get200_response_data.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HelpEventsEventIdViewGet200ResponseData {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [HelpEventsEventIdViewGet200ResponseData] instance.
HelpEventsEventIdViewGet200ResponseData({
  required  this.eventId,
  required  this.status,
  required  this.rescuee,
  required  this.location,
  required  this.rescuerCount,
  required  this.createdAt,
  this.acceptedRescuers = const [],
  required  this.updatedAt,
});

  @JsonKey(
    
    name: r'eventId',
    required: true,
    includeIfNull: false,
  )


  final String eventId;



      /// Help event status
  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final HelpEventsEventIdViewGet200ResponseDataStatusEnum status;



  @JsonKey(
    
    name: r'rescuee',
    required: true,
    includeIfNull: false,
  )


  final HelpEventRescuee rescuee;



  @JsonKey(
    
    name: r'location',
    required: true,
    includeIfNull: false,
  )


  final HelpEventLocationOutput location;



          // minimum: -9007199254740991
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'rescuerCount',
    required: true,
    includeIfNull: false,
  )


  final int rescuerCount;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'acceptedRescuers',
    required: true,
    includeIfNull: false,
  )


  final List<HelpEventParticipation> acceptedRescuers;



  @JsonKey(
    
    name: r'updatedAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? updatedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is HelpEventsEventIdViewGet200ResponseData &&
      other.eventId == eventId &&
      other.status == status &&
      other.rescuee == rescuee &&
      other.location == location &&
      other.rescuerCount == rescuerCount &&
      other.createdAt == createdAt &&
      other.acceptedRescuers == acceptedRescuers &&
      other.updatedAt == updatedAt;

    @override
    int get hashCode =>
        eventId.hashCode +
        status.hashCode +
        rescuee.hashCode +
        location.hashCode +
        rescuerCount.hashCode +
        createdAt.hashCode +
        acceptedRescuers.hashCode +
        (updatedAt == null ? 0 : updatedAt.hashCode);

  factory HelpEventsEventIdViewGet200ResponseData.fromJson(Map<String, dynamic> json) => _$HelpEventsEventIdViewGet200ResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$HelpEventsEventIdViewGet200ResponseDataToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

/// Help event status
enum HelpEventsEventIdViewGet200ResponseDataStatusEnum {
    /// Help event status
@JsonValue(r'active')
active(r'active'),
    /// Help event status
@JsonValue(r'completed')
completed(r'completed'),
    /// Help event status
@JsonValue(r'cancelled')
cancelled(r'cancelled');

const HelpEventsEventIdViewGet200ResponseDataStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


