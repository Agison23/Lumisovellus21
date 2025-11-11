//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'help_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HelpRequest {
  /// Returns a new [HelpRequest] instance.
  HelpRequest({

    required  this.timestamp,

    required  this.deviceId,

    required  this.gpsCoord,

    required  this.helpType,

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



      /// Device identifier
  @JsonKey(
    
    name: r'deviceId',
    required: true,
    includeIfNull: false,
  )


  final String deviceId;



      /// GPS coordinates (format: \"lat,lng\")
  @JsonKey(
    
    name: r'gpsCoord',
    required: true,
    includeIfNull: false,
  )


  final String gpsCoord;



      /// Type of help request
  @JsonKey(
    
    name: r'helpType',
    required: true,
    includeIfNull: false,
  )


  final HelpRequestHelpTypeEnum helpType;



      /// Chat room identifier
  @JsonKey(
    
    name: r'chatRoomId',
    required: true,
    includeIfNull: false,
  )


  final String chatRoomId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is HelpRequest &&
      other.timestamp == timestamp &&
      other.deviceId == deviceId &&
      other.gpsCoord == gpsCoord &&
      other.helpType == helpType &&
      other.chatRoomId == chatRoomId;

    @override
    int get hashCode =>
        timestamp.hashCode +
        deviceId.hashCode +
        gpsCoord.hashCode +
        helpType.hashCode +
        chatRoomId.hashCode;

  factory HelpRequest.fromJson(Map<String, dynamic> json) => _$HelpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$HelpRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

/// Type of help request
enum HelpRequestHelpTypeEnum {
    /// Type of help request
@JsonValue(r'seriousEmerg')
seriousEmerg(r'seriousEmerg'),
    /// Type of help request
@JsonValue(r'help')
help(r'help');

const HelpRequestHelpTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


