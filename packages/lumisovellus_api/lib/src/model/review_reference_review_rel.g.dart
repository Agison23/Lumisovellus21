// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_reference_review_rel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewReferenceReviewRel _$ReviewReferenceReviewRelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ReviewReferenceReviewRel', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'time',
      'segment',
      'snowType',
      'secondarySnowType',
      'hazards',
      'comment',
      'userId',
      'createdAt',
      'updatedAt',
    ],
  );
  final val = ReviewReferenceReviewRel(
    id: $checkedConvert('id', (v) => v as String),
    time: $checkedConvert('time', (v) => DateTime.parse(v as String)),
    segment: $checkedConvert('segment', (v) => v as String),
    snowType: $checkedConvert('snowType', (v) => v as String?),
    secondarySnowType: $checkedConvert(
      'secondarySnowType',
      (v) => v as String?,
    ),
    hazards: $checkedConvert('hazards', (v) => v),
    comment: $checkedConvert('comment', (v) => v as String?),
    userId: $checkedConvert('userId', (v) => v as String?),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$ReviewReferenceReviewRelToJson(
  ReviewReferenceReviewRel instance,
) => <String, dynamic>{
  'id': instance.id,
  'time': instance.time.toIso8601String(),
  'segment': instance.segment,
  'snowType': instance.snowType,
  'secondarySnowType': instance.secondarySnowType,
  'hazards': instance.hazards,
  'comment': instance.comment,
  'userId': instance.userId,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
