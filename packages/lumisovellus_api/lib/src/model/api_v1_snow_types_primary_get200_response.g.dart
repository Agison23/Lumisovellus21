// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_snow_types_primary_get200_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiV1SnowTypesPrimaryGet200Response
_$ApiV1SnowTypesPrimaryGet200ResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ApiV1SnowTypesPrimaryGet200Response', json, (
      $checkedConvert,
    ) {
      $checkKeys(json, requiredKeys: const ['success', 'data', 'meta']);
      final val = ApiV1SnowTypesPrimaryGet200Response(
        success: $checkedConvert('success', (v) => v as bool),
        data: $checkedConvert(
          'data',
          (v) =>
              (v as List<dynamic>?)
                  ?.map(
                    (e) => PrimarySnowTypeWithSecondaries.fromJson(
                      e as Map<String, dynamic>,
                    ),
                  )
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

Map<String, dynamic> _$ApiV1SnowTypesPrimaryGet200ResponseToJson(
  ApiV1SnowTypesPrimaryGet200Response instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.map((e) => e.toJson()).toList(),
  'meta': instance.meta.toJson(),
};
