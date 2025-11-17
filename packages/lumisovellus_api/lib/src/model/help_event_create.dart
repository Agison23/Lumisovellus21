//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:lumisovellus_api/src/model/help_event_location.dart';
import 'package:json_annotation/json_annotation.dart';

part 'help_event_create.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HelpEventCreate {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [HelpEventCreate] instance.
HelpEventCreate({
  required  this.timestamp,
  required  this.location,
  required  this.needType,
  required  this.chatRoomId,
});

      /// Unix timestamp
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'timestamp',
    required: true,
    includeIfNull: false,
  )


  final int timestamp;



  @JsonKey(
    
    name: r'location',
    required: true,
    includeIfNull: false,
  )


  final HelpEventLocation location;



      /// Type of help requested
  @JsonKey(
    
    name: r'needType',
    required: true,
    includeIfNull: false,
  )


  final HelpEventCreateNeedTypeEnum needType;



      /// Chat room identifier
  @JsonKey(
    
    name: r'chatRoomId',
    required: true,
    includeIfNull: false,
  )


  final String chatRoomId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is HelpEventCreate &&
      other.timestamp == timestamp &&
      other.location == location &&
      other.needType == needType &&
      other.chatRoomId == chatRoomId;

    @override
    int get hashCode =>
        timestamp.hashCode +
        location.hashCode +
        needType.hashCode +
        chatRoomId.hashCode;

  factory HelpEventCreate.fromJson(Map<String, dynamic> json) => _$HelpEventCreateFromJson(json);

  Map<String, dynamic> toJson() => _$HelpEventCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

/// Type of help requested
enum HelpEventCreateNeedTypeEnum {
    /// Type of help requested
@JsonValue(r'health')
health(r'health'),
    /// Type of help requested
@JsonValue(r'equipment')
equipment(r'equipment'),
    /// Type of help requested
@JsonValue(r'lost')
lost(r'lost');

const HelpEventCreateNeedTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


