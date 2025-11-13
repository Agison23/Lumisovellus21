// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_users_device_id_location_post200_response_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiV1UsersDeviceIdLocationPost200ResponseData
_$ApiV1UsersDeviceIdLocationPost200ResponseDataFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ApiV1UsersDeviceIdLocationPost200ResponseData', json, (
  $checkedConvert,
) {
  $checkKeys(json, requiredKeys: const ['status']);
  final val = ApiV1UsersDeviceIdLocationPost200ResponseData(
    status: $checkedConvert('status', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$ApiV1UsersDeviceIdLocationPost200ResponseDataToJson(
  ApiV1UsersDeviceIdLocationPost200ResponseData instance,
) => <String, dynamic>{'status': instance.status};
