// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_snow_types_post201_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiV1SnowTypesPost201Response _$ApiV1SnowTypesPost201ResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ApiV1SnowTypesPost201Response', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['success', 'data', 'meta']);
  final val = ApiV1SnowTypesPost201Response(
    success: $checkedConvert('success', (v) => v as bool),
    data: $checkedConvert(
      'data',
      (v) => SnowType.fromJson(v as Map<String, dynamic>),
    ),
    meta: $checkedConvert(
      'meta',
      (v) => HealthGet200ResponseMeta.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$ApiV1SnowTypesPost201ResponseToJson(
  ApiV1SnowTypesPost201Response instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.toJson(),
  'meta': instance.meta.toJson(),
};
