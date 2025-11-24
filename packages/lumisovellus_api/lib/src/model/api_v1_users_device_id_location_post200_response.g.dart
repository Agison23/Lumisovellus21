// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_users_device_id_location_post200_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiV1UsersDeviceIdLocationPost200Response
_$ApiV1UsersDeviceIdLocationPost200ResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ApiV1UsersDeviceIdLocationPost200Response', json, (
  $checkedConvert,
) {
  $checkKeys(json, requiredKeys: const ['success', 'data', 'meta']);
  final val = ApiV1UsersDeviceIdLocationPost200Response(
    success: $checkedConvert('success', (v) => v as bool),
    data: $checkedConvert(
      'data',
      (v) => ApiV1UsersDeviceIdLocationPost200ResponseData.fromJson(
        v as Map<String, dynamic>,
      ),
    ),
    meta: $checkedConvert(
      'meta',
      (v) => HealthGet200ResponseMeta.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$ApiV1UsersDeviceIdLocationPost200ResponseToJson(
  ApiV1UsersDeviceIdLocationPost200Response instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.toJson(),
  'meta': instance.meta.toJson(),
};
