// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_event_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelpEventSummary _$HelpEventSummaryFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('HelpEventSummary', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'eventId',
      'status',
      'rescuee',
      'location',
      'rescuerCount',
      'createdAt',
    ],
  );
  final val = HelpEventSummary(
    eventId: $checkedConvert('eventId', (v) => v as String),
    status: $checkedConvert(
      'status',
      (v) => $enumDecode(_$HelpEventSummaryStatusEnumEnumMap, v),
    ),
    rescuee: $checkedConvert(
      'rescuee',
      (v) => HelpEventRescuee.fromJson(v as Map<String, dynamic>),
    ),
    location: $checkedConvert(
      'location',
      (v) => HelpEventLocationOutput.fromJson(v as Map<String, dynamic>),
    ),
    rescuerCount: $checkedConvert('rescuerCount', (v) => (v as num).toInt()),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$HelpEventSummaryToJson(HelpEventSummary instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'status': _$HelpEventSummaryStatusEnumEnumMap[instance.status]!,
      'rescuee': instance.rescuee.toJson(),
      'location': instance.location.toJson(),
      'rescuerCount': instance.rescuerCount,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$HelpEventSummaryStatusEnumEnumMap = {
  HelpEventSummaryStatusEnum.active: 'active',
  HelpEventSummaryStatusEnum.completed: 'completed',
  HelpEventSummaryStatusEnum.cancelled: 'cancelled',
};
