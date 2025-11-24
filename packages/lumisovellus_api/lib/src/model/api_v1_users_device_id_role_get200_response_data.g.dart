// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_users_device_id_role_get200_response_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiV1UsersDeviceIdRoleGet200ResponseData
_$ApiV1UsersDeviceIdRoleGet200ResponseDataFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ApiV1UsersDeviceIdRoleGet200ResponseData', json, (
      $checkedConvert,
    ) {
      $checkKeys(json, requiredKeys: const ['role', 'permissions']);
      final val = ApiV1UsersDeviceIdRoleGet200ResponseData(
        role: $checkedConvert('role', (v) => v as String),
        permissions: $checkedConvert('permissions', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ApiV1UsersDeviceIdRoleGet200ResponseDataToJson(
  ApiV1UsersDeviceIdRoleGet200ResponseData instance,
) => <String, dynamic>{
  'role': instance.role,
  'permissions': instance.permissions,
};
