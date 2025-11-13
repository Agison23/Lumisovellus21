// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_get200_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthGet200Response _$HealthGet200ResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('HealthGet200Response', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['success', 'data', 'meta']);
  final val = HealthGet200Response(
    success: $checkedConvert('success', (v) => v as bool),
    data: $checkedConvert(
      'data',
      (v) => HealthResponse.fromJson(v as Map<String, dynamic>),
    ),
    meta: $checkedConvert(
      'meta',
      (v) => HealthGet200ResponseMeta.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$HealthGet200ResponseToJson(
  HealthGet200Response instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.toJson(),
  'meta': instance.meta.toJson(),
};
