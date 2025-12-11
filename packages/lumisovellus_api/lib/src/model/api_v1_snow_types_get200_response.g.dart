// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_snow_types_get200_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiV1SnowTypesGet200Response _$ApiV1SnowTypesGet200ResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ApiV1SnowTypesGet200Response', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['success', 'data', 'meta']);
  final val = ApiV1SnowTypesGet200Response(
    success: $checkedConvert('success', (v) => v as bool),
    data: $checkedConvert(
      'data',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => SnowType.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    ),
    meta: $checkedConvert(
      'meta',
      (v) => HealthGet200ResponseMeta.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$ApiV1SnowTypesGet200ResponseToJson(
  ApiV1SnowTypesGet200Response instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.map((e) => e.toJson()).toList(),
  'meta': instance.meta.toJson(),
};
