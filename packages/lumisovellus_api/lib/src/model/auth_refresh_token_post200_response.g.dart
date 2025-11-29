// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_refresh_token_post200_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthRefreshTokenPost200Response _$AuthRefreshTokenPost200ResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AuthRefreshTokenPost200Response', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['success', 'data', 'meta']);
  final val = AuthRefreshTokenPost200Response(
    success: $checkedConvert('success', (v) => v as bool),
    data: $checkedConvert(
      'data',
      (v) => TokenPair.fromJson(v as Map<String, dynamic>),
    ),
    meta: $checkedConvert(
      'meta',
      (v) => HealthGet200ResponseMeta.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$AuthRefreshTokenPost200ResponseToJson(
  AuthRefreshTokenPost200Response instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.toJson(),
  'meta': instance.meta.toJson(),
};
