// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_users_device_id_role_get200_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiV1UsersDeviceIdRoleGet200Response
_$ApiV1UsersDeviceIdRoleGet200ResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ApiV1UsersDeviceIdRoleGet200Response', json, (
      $checkedConvert,
    ) {
      $checkKeys(json, requiredKeys: const ['success', 'data', 'meta']);
      final val = ApiV1UsersDeviceIdRoleGet200Response(
        success: $checkedConvert('success', (v) => v as bool),
        data: $checkedConvert(
          'data',
          (v) => ApiV1UsersDeviceIdRoleGet200ResponseData.fromJson(
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

Map<String, dynamic> _$ApiV1UsersDeviceIdRoleGet200ResponseToJson(
  ApiV1UsersDeviceIdRoleGet200Response instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.toJson(),
  'meta': instance.meta.toJson(),
};
