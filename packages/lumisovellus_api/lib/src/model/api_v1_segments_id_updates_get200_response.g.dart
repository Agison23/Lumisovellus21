// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_segments_id_updates_get200_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiV1SegmentsIdUpdatesGet200Response
_$ApiV1SegmentsIdUpdatesGet200ResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ApiV1SegmentsIdUpdatesGet200Response', json, (
      $checkedConvert,
    ) {
      $checkKeys(json, requiredKeys: const ['success', 'data', 'meta']);
      final val = ApiV1SegmentsIdUpdatesGet200Response(
        success: $checkedConvert('success', (v) => v as bool),
        data: $checkedConvert(
          'data',
          (v) => (v as List<dynamic>)
              .map((e) => SegmentUpdate.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        meta: $checkedConvert(
          'meta',
          (v) => HealthGet200ResponseMeta.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ApiV1SegmentsIdUpdatesGet200ResponseToJson(
  ApiV1SegmentsIdUpdatesGet200Response instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.map((e) => e.toJson()).toList(),
  'meta': instance.meta.toJson(),
};
