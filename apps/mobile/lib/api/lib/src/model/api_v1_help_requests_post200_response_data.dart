//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'api_v1_help_requests_post200_response_data.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ApiV1HelpRequestsPost200ResponseData {
  /// Returns a new [ApiV1HelpRequestsPost200ResponseData] instance.
  ApiV1HelpRequestsPost200ResponseData({

    required  this.status,

    required  this.nearbyUsers,
  });

  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'nearbyUsers',
    required: true,
    includeIfNull: false,
  )


  final num nearbyUsers;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ApiV1HelpRequestsPost200ResponseData &&
      other.status == status &&
      other.nearbyUsers == nearbyUsers;

    @override
    int get hashCode =>
        status.hashCode +
        nearbyUsers.hashCode;

  factory ApiV1HelpRequestsPost200ResponseData.fromJson(Map<String, dynamic> json) => _$ApiV1HelpRequestsPost200ResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$ApiV1HelpRequestsPost200ResponseDataToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

