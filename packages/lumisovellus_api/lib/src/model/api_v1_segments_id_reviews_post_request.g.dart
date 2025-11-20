// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_segments_id_reviews_post_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiV1SegmentsIdReviewsPostRequest _$ApiV1SegmentsIdReviewsPostRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ApiV1SegmentsIdReviewsPostRequest', json, (
  $checkedConvert,
) {
  $checkKeys(json, requiredKeys: const ['snowType']);
  final val = ApiV1SegmentsIdReviewsPostRequest(
    snowType: $checkedConvert('snowType', (v) => v as String),
    hazards: $checkedConvert(
      'hazards',
      (v) =>
          (v as List<dynamic>?)
              ?.map(
                (e) => $enumDecode(
                  _$ApiV1SegmentsIdReviewsPostRequestHazardsEnumEnumMap,
                  e,
                ),
              )
              .toList() ??
          [],
    ),
    comment: $checkedConvert('comment', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$ApiV1SegmentsIdReviewsPostRequestToJson(
  ApiV1SegmentsIdReviewsPostRequest instance,
) => <String, dynamic>{
  'snowType': instance.snowType,
  'hazards': ?instance.hazards
      ?.map((e) => _$ApiV1SegmentsIdReviewsPostRequestHazardsEnumEnumMap[e]!)
      .toList(),
  'comment': ?instance.comment,
};

const _$ApiV1SegmentsIdReviewsPostRequestHazardsEnumEnumMap = {
  ApiV1SegmentsIdReviewsPostRequestHazardsEnum.stones: 'stones',
  ApiV1SegmentsIdReviewsPostRequestHazardsEnum.branches: 'branches',
};
