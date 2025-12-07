// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_register_post201_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthRegisterPost201Response _$AuthRegisterPost201ResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AuthRegisterPost201Response', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['success', 'data', 'meta']);
  final val = AuthRegisterPost201Response(
    success: $checkedConvert('success', (v) => v as bool),
    data: $checkedConvert(
      'data',
      (v) => AuthResponse.fromJson(v as Map<String, dynamic>),
    ),
    meta: $checkedConvert(
      'meta',
      (v) => HealthGet200ResponseMeta.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$AuthRegisterPost201ResponseToJson(
  AuthRegisterPost201Response instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.toJson(),
  'meta': instance.meta.toJson(),
};
