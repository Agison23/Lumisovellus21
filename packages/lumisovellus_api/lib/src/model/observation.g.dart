// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'observation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Observation _$ObservationFromJson(Map<String, dynamic> json) => $checkedCreate(
  'Observation',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const ['segmentId', 'guideUpdate', 'userReviews'],
    );
    final val = Observation(
      segmentId: $checkedConvert('segmentId', (v) => v as String),
      guideUpdate: $checkedConvert(
        'guideUpdate',
        (v) => v == null
            ? null
            : GuideUpdateRequestOutput.fromJson(v as Map<String, dynamic>),
      ),
      userReviews: $checkedConvert(
        'userReviews',
        (v) =>
            (v as List<dynamic>?)
                ?.map(
                  (e) =>
                      UserReviewObservation.fromJson(e as Map<String, dynamic>),
                )
                .toList() ??
            const [],
      ),
    );
    return val;
  },
);

Map<String, dynamic> _$ObservationToJson(Observation instance) =>
    <String, dynamic>{
      'segmentId': instance.segmentId,
      'guideUpdate': instance.guideUpdate?.toJson(),
      'userReviews': instance.userReviews.map((e) => e.toJson()).toList(),
    };
