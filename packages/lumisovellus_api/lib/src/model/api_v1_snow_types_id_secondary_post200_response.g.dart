// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_snow_types_id_secondary_post200_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiV1SnowTypesIdSecondaryPost200Response
_$ApiV1SnowTypesIdSecondaryPost200ResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ApiV1SnowTypesIdSecondaryPost200Response', json, (
      $checkedConvert,
    ) {
      $checkKeys(json, requiredKeys: const ['success', 'data', 'meta']);
      final val = ApiV1SnowTypesIdSecondaryPost200Response(
        success: $checkedConvert('success', (v) => v as bool),
        data: $checkedConvert('data', (v) => v),
        meta: $checkedConvert(
          'meta',
          (v) => HealthGet200ResponseMeta.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ApiV1SnowTypesIdSecondaryPost200ResponseToJson(
  ApiV1SnowTypesIdSecondaryPost200Response instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'meta': instance.meta.toJson(),
};
