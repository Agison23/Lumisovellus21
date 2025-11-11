//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'api_v1_help_requests_id_helpers_get200_response_data_inner.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ApiV1HelpRequestsIdHelpersGet200ResponseDataInner {
  /// Returns a new [ApiV1HelpRequestsIdHelpersGet200ResponseDataInner] instance.
  ApiV1HelpRequestsIdHelpersGet200ResponseDataInner({

    required  this.userId,

    required  this.firstName,

    required  this.lastName,

    required  this.phoneNumber,

    required  this.distance,

    required  this.state,

    required  this.lowBattery,

    required  this.lastSeen,
  });

  @JsonKey(
    
    name: r'userId',
    required: true,
    includeIfNull: false,
  )


  final String userId;



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
    
    name: r'phoneNumber',
    required: true,
    includeIfNull: true,
  )


  final String? phoneNumber;



  @JsonKey(
    
    name: r'distance',
    required: true,
    includeIfNull: false,
  )


  final num distance;



  @JsonKey(
    
    name: r'state',
    required: true,
    includeIfNull: false,
  )


  final num state;



  @JsonKey(
    
    name: r'lowBattery',
    required: true,
    includeIfNull: false,
  )


  final num lowBattery;



  @JsonKey(
    
    name: r'lastSeen',
    required: true,
    includeIfNull: false,
  )


  final DateTime lastSeen;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ApiV1HelpRequestsIdHelpersGet200ResponseDataInner &&
      other.userId == userId &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.phoneNumber == phoneNumber &&
      other.distance == distance &&
      other.state == state &&
      other.lowBattery == lowBattery &&
      other.lastSeen == lastSeen;

    @override
    int get hashCode =>
        userId.hashCode +
        firstName.hashCode +
        (lastName == null ? 0 : lastName.hashCode) +
        (phoneNumber == null ? 0 : phoneNumber.hashCode) +
        distance.hashCode +
        state.hashCode +
        lowBattery.hashCode +
        lastSeen.hashCode;

  factory ApiV1HelpRequestsIdHelpersGet200ResponseDataInner.fromJson(Map<String, dynamic> json) => _$ApiV1HelpRequestsIdHelpersGet200ResponseDataInnerFromJson(json);

  Map<String, dynamic> toJson() => _$ApiV1HelpRequestsIdHelpersGet200ResponseDataInnerToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

