// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_segments_id_reviews_post201_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiV1SegmentsIdReviewsPost201Response
_$ApiV1SegmentsIdReviewsPost201ResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ApiV1SegmentsIdReviewsPost201Response', json, (
      $checkedConvert,
    ) {
      $checkKeys(json, requiredKeys: const ['success', 'data', 'meta']);
      final val = ApiV1SegmentsIdReviewsPost201Response(
        success: $checkedConvert('success', (v) => v as bool),
        data: $checkedConvert(
          'data',
          (v) => ReviewResponse.fromJson(v as Map<String, dynamic>),
        ),
        meta: $checkedConvert(
          'meta',
          (v) => HealthGet200ResponseMeta.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ApiV1SegmentsIdReviewsPost201ResponseToJson(
  ApiV1SegmentsIdReviewsPost201Response instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.toJson(),
  'meta': instance.meta.toJson(),
};
