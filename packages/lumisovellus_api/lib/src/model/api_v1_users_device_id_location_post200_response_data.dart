//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'api_v1_users_device_id_location_post200_response_data.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ApiV1UsersDeviceIdLocationPost200ResponseData {
  /// Returns a new [ApiV1UsersDeviceIdLocationPost200ResponseData] instance.
  ApiV1UsersDeviceIdLocationPost200ResponseData({

    required  this.status,
  });

  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ApiV1UsersDeviceIdLocationPost200ResponseData &&
      other.status == status;

    @override
    int get hashCode =>
        status.hashCode;

  factory ApiV1UsersDeviceIdLocationPost200ResponseData.fromJson(Map<String, dynamic> json) => _$ApiV1UsersDeviceIdLocationPost200ResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$ApiV1UsersDeviceIdLocationPost200ResponseDataToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

