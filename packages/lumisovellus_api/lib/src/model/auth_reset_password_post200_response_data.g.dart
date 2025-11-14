// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_reset_password_post200_response_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResetPasswordPost200ResponseData
_$AuthResetPasswordPost200ResponseDataFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AuthResetPasswordPost200ResponseData', json, (
      $checkedConvert,
    ) {
      $checkKeys(json, requiredKeys: const ['message']);
      final val = AuthResetPasswordPost200ResponseData(
        message: $checkedConvert('message', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AuthResetPasswordPost200ResponseDataToJson(
  AuthResetPasswordPost200ResponseData instance,
) => <String, dynamic>{'message': instance.message};
