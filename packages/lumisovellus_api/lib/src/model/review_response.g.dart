// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewResponse _$ReviewResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ReviewResponse', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['id', 'time', 'segment', 'hazards']);
  final val = ReviewResponse(
    id: $checkedConvert('id', (v) => v as String),
    time: $checkedConvert('time', (v) => DateTime.parse(v as String)),
    segment: $checkedConvert('segment', (v) => v as String),
    snowType: $checkedConvert('snowType', (v) => v as String?),
    secondarySnowType: $checkedConvert(
      'secondarySnowType',
      (v) => v as String?,
    ),
    hazards: $checkedConvert(
      'hazards',
      (v) =>
          (v as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    ),
    comment: $checkedConvert('comment', (v) => v as String?),
    userId: $checkedConvert('userId', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$ReviewResponseToJson(ReviewResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'time': instance.time.toIso8601String(),
      'segment': instance.segment,
      'snowType': ?instance.snowType,
      'secondarySnowType': ?instance.secondarySnowType,
      'hazards': instance.hazards,
      'comment': ?instance.comment,
      'userId': ?instance.userId,
    };
