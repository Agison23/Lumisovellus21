// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_verify_token_get200_response_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthVerifyTokenGet200ResponseData _$AuthVerifyTokenGet200ResponseDataFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AuthVerifyTokenGet200ResponseData', json, (
  $checkedConvert,
) {
  $checkKeys(json, requiredKeys: const ['valid', 'user']);
  final val = AuthVerifyTokenGet200ResponseData(
    valid: $checkedConvert('valid', (v) => v as bool),
    user: $checkedConvert(
      'user',
      (v) => AuthVerifyTokenGet200ResponseDataUser.fromJson(
        v as Map<String, dynamic>,
      ),
    ),
  );
  return val;
});

Map<String, dynamic> _$AuthVerifyTokenGet200ResponseDataToJson(
  AuthVerifyTokenGet200ResponseData instance,
) => <String, dynamic>{'valid': instance.valid, 'user': instance.user.toJson()};
