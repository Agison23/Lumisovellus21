// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_review_observation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserReviewObservation _$UserReviewObservationFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('UserReviewObservation', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['submittedAt', 'snowTypeId', 'hazards'],
  );
  final val = UserReviewObservation(
    submittedAt: $checkedConvert(
      'submittedAt',
      (v) => DateTime.parse(v as String),
    ),
    snowTypeId: $checkedConvert('snowTypeId', (v) => v as String),
    hazards: $checkedConvert(
      'hazards',
      (v) =>
          (v as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    ),
  );
  return val;
});

Map<String, dynamic> _$UserReviewObservationToJson(
  UserReviewObservation instance,
) => <String, dynamic>{
  'submittedAt': instance.submittedAt.toIso8601String(),
  'snowTypeId': instance.snowTypeId,
  'hazards': instance.hazards,
};
