// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'segment_user_review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SegmentUserReview _$SegmentUserReviewFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SegmentUserReview', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['submittedAt', 'snowTypeId', 'hazards'],
      );
      final val = SegmentUserReview(
        submittedAt: $checkedConvert(
          'submittedAt',
          (v) => DateTime.parse(v as String),
        ),
        snowTypeId: $checkedConvert('snowTypeId', (v) => v as String),
        secondarySnowTypeId: $checkedConvert(
          'secondarySnowTypeId',
          (v) => v as String?,
        ),
        hazards: $checkedConvert(
          'hazards',
          (v) =>
              (v as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
        ),
      );
      return val;
    });

Map<String, dynamic> _$SegmentUserReviewToJson(SegmentUserReview instance) =>
    <String, dynamic>{
      'submittedAt': instance.submittedAt.toIso8601String(),
      'snowTypeId': instance.snowTypeId,
      'secondarySnowTypeId': ?instance.secondarySnowTypeId,
      'hazards': instance.hazards,
    };
