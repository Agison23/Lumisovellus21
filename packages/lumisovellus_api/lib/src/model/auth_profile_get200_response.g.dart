// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_profile_get200_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthProfileGet200Response _$AuthProfileGet200ResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AuthProfileGet200Response', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['success', 'data', 'meta']);
  final val = AuthProfileGet200Response(
    success: $checkedConvert('success', (v) => v as bool),
    data: $checkedConvert(
      'data',
      (v) => User.fromJson(v as Map<String, dynamic>),
    ),
    meta: $checkedConvert(
      'meta',
      (v) => HealthGet200ResponseMeta.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$AuthProfileGet200ResponseToJson(
  AuthProfileGet200Response instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.toJson(),
  'meta': instance.meta.toJson(),
};
