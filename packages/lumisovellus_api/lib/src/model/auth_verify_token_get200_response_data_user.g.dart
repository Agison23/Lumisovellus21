// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_verify_token_get200_response_data_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthVerifyTokenGet200ResponseDataUser
_$AuthVerifyTokenGet200ResponseDataUserFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AuthVerifyTokenGet200ResponseDataUser', json, (
      $checkedConvert,
    ) {
      $checkKeys(
        json,
        requiredKeys: const ['id', 'firstName', 'lastName', 'email', 'role'],
      );
      final val = AuthVerifyTokenGet200ResponseDataUser(
        id: $checkedConvert('id', (v) => v as String),
        firstName: $checkedConvert('firstName', (v) => v as String),
        lastName: $checkedConvert('lastName', (v) => v as String?),
        email: $checkedConvert('email', (v) => v as String?),
        role: $checkedConvert('role', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AuthVerifyTokenGet200ResponseDataUserToJson(
  AuthVerifyTokenGet200ResponseDataUser instance,
) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'role': instance.role,
};
