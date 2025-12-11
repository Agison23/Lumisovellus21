// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_event_rescuer_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelpEventRescuerView _$HelpEventRescuerViewFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('HelpEventRescuerView', json, ($checkedConvert) {
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
  final val = HelpEventRescuerView(
    eventId: $checkedConvert('eventId', (v) => v as String),
    status: $checkedConvert(
      'status',
      (v) => $enumDecode(_$HelpEventRescuerViewStatusEnumEnumMap, v),
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

Map<String, dynamic> _$HelpEventRescuerViewToJson(
  HelpEventRescuerView instance,
) => <String, dynamic>{
  'eventId': instance.eventId,
  'status': _$HelpEventRescuerViewStatusEnumEnumMap[instance.status]!,
  'rescuee': instance.rescuee.toJson(),
  'location': instance.location.toJson(),
  'rescuerCount': instance.rescuerCount,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$HelpEventRescuerViewStatusEnumEnumMap = {
  HelpEventRescuerViewStatusEnum.active: 'active',
  HelpEventRescuerViewStatusEnum.completed: 'completed',
  HelpEventRescuerViewStatusEnum.cancelled: 'cancelled',
};
