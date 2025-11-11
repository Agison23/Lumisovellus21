// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_segments_id_guide_update_post200_response_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiV1SegmentsIdGuideUpdatePost200ResponseData
_$ApiV1SegmentsIdGuideUpdatePost200ResponseDataFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ApiV1SegmentsIdGuideUpdatePost200ResponseData', json, (
  $checkedConvert,
) {
  $checkKeys(
    json,
    requiredKeys: const [
      'description',
      'primarySnowTypeIds',
      'secondarySnowTypeIds',
    ],
  );
  final val = ApiV1SegmentsIdGuideUpdatePost200ResponseData(
    description: $checkedConvert('description', (v) => v as String?),
    primarySnowTypeIds: $checkedConvert(
      'primarySnowTypeIds',
      (v) => (v as List<dynamic>).map((e) => e as String).toList(),
    ),
    secondarySnowTypeIds: $checkedConvert(
      'secondarySnowTypeIds',
      (v) => (v as List<dynamic>).map((e) => e as String).toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$ApiV1SegmentsIdGuideUpdatePost200ResponseDataToJson(
  ApiV1SegmentsIdGuideUpdatePost200ResponseData instance,
) => <String, dynamic>{
  'description': instance.description,
  'primarySnowTypeIds': instance.primarySnowTypeIds,
  'secondarySnowTypeIds': instance.secondarySnowTypeIds,
};
