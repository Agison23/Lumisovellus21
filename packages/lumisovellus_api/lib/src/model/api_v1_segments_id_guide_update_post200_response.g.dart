// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_segments_id_guide_update_post200_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiV1SegmentsIdGuideUpdatePost200Response
_$ApiV1SegmentsIdGuideUpdatePost200ResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ApiV1SegmentsIdGuideUpdatePost200Response', json, (
  $checkedConvert,
) {
  $checkKeys(json, requiredKeys: const ['success', 'data', 'meta']);
  final val = ApiV1SegmentsIdGuideUpdatePost200Response(
    success: $checkedConvert('success', (v) => v as bool),
    data: $checkedConvert(
      'data',
      (v) => ApiV1SegmentsIdGuideUpdatePost200ResponseData.fromJson(
        v as Map<String, dynamic>,
      ),
    ),
    meta: $checkedConvert(
      'meta',
      (v) => HealthGet200ResponseMeta.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$ApiV1SegmentsIdGuideUpdatePost200ResponseToJson(
  ApiV1SegmentsIdGuideUpdatePost200Response instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.toJson(),
  'meta': instance.meta.toJson(),
};
