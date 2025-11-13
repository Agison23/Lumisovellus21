// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'segment_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SegmentUpdate _$SegmentUpdateFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('SegmentUpdate', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'segment',
      'time',
      'description',
      'weather',
      'temperature',
      'windSpeed',
      'visibility',
      'status',
      'priority',
      'creator',
      'segmentName',
      'snowConditions',
      'reviewReferences',
    ],
  );
  final val = SegmentUpdate(
    id: $checkedConvert('id', (v) => v as String),
    segment: $checkedConvert('segment', (v) => v as String),
    time: $checkedConvert('time', (v) => DateTime.parse(v as String)),
    description: $checkedConvert('description', (v) => v as String?),
    weather: $checkedConvert('weather', (v) => v as String?),
    temperature: $checkedConvert('temperature', (v) => v as num?),
    windSpeed: $checkedConvert('windSpeed', (v) => v as num?),
    visibility: $checkedConvert('visibility', (v) => v as num?),
    status: $checkedConvert(
      'status',
      (v) => $enumDecode(_$SegmentUpdateStatusEnumEnumMap, v),
    ),
    priority: $checkedConvert('priority', (v) => (v as num).toInt()),
    creator: $checkedConvert(
      'creator',
      (v) => v == null ? null : Creator.fromJson(v as Map<String, dynamic>),
    ),
    segmentName: $checkedConvert('segmentName', (v) => v as String),
    snowConditions: $checkedConvert(
      'snowConditions',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => SnowCondition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    ),
    reviewReferences: $checkedConvert(
      'reviewReferences',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => ReviewReference.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    ),
  );
  return val;
});

Map<String, dynamic> _$SegmentUpdateToJson(
  SegmentUpdate instance,
) => <String, dynamic>{
  'id': instance.id,
  'segment': instance.segment,
  'time': instance.time.toIso8601String(),
  'description': instance.description,
  'weather': instance.weather,
  'temperature': instance.temperature,
  'windSpeed': instance.windSpeed,
  'visibility': instance.visibility,
  'status': _$SegmentUpdateStatusEnumEnumMap[instance.status]!,
  'priority': instance.priority,
  'creator': instance.creator?.toJson(),
  'segmentName': instance.segmentName,
  'snowConditions': instance.snowConditions.map((e) => e.toJson()).toList(),
  'reviewReferences': instance.reviewReferences.map((e) => e.toJson()).toList(),
};

const _$SegmentUpdateStatusEnumEnumMap = {
  SegmentUpdateStatusEnum.DRAFT: 'DRAFT',
  SegmentUpdateStatusEnum.ACTIVE: 'ACTIVE',
  SegmentUpdateStatusEnum.ARCHIVED: 'ARCHIVED',
  SegmentUpdateStatusEnum.DELETED: 'DELETED',
};
