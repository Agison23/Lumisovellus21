// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_verify_token_get200_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthVerifyTokenGet200Response _$AuthVerifyTokenGet200ResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AuthVerifyTokenGet200Response', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['success', 'data', 'meta']);
  final val = AuthVerifyTokenGet200Response(
    success: $checkedConvert('success', (v) => v as bool),
    data: $checkedConvert(
      'data',
      (v) =>
          AuthVerifyTokenGet200ResponseData.fromJson(v as Map<String, dynamic>),
    ),
    meta: $checkedConvert(
      'meta',
      (v) => HealthGet200ResponseMeta.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$AuthVerifyTokenGet200ResponseToJson(
  AuthVerifyTokenGet200Response instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.toJson(),
  'meta': instance.meta.toJson(),
};
