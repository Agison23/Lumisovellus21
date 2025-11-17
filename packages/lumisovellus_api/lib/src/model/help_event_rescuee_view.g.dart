// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_event_rescuee_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelpEventRescueeView _$HelpEventRescueeViewFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('HelpEventRescueeView', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'eventId',
      'status',
      'rescuee',
      'location',
      'rescuerCount',
      'createdAt',
      'acceptedRescuers',
      'updatedAt',
    ],
  );
  final val = HelpEventRescueeView(
    eventId: $checkedConvert('eventId', (v) => v as String),
    status: $checkedConvert(
      'status',
      (v) => $enumDecode(_$HelpEventRescueeViewStatusEnumEnumMap, v),
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
    acceptedRescuers: $checkedConvert(
      'acceptedRescuers',
      (v) =>
          (v as List<dynamic>?)
              ?.map(
                (e) =>
                    HelpEventParticipation.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    ),
    updatedAt: $checkedConvert(
      'updatedAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
  );
  return val;
});

Map<String, dynamic> _$HelpEventRescueeViewToJson(
  HelpEventRescueeView instance,
) => <String, dynamic>{
  'eventId': instance.eventId,
  'status': _$HelpEventRescueeViewStatusEnumEnumMap[instance.status]!,
  'rescuee': instance.rescuee.toJson(),
  'location': instance.location.toJson(),
  'rescuerCount': instance.rescuerCount,
  'createdAt': instance.createdAt.toIso8601String(),
  'acceptedRescuers': instance.acceptedRescuers.map((e) => e.toJson()).toList(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$HelpEventRescueeViewStatusEnumEnumMap = {
  HelpEventRescueeViewStatusEnum.active: 'active',
  HelpEventRescueeViewStatusEnum.completed: 'completed',
  HelpEventRescueeViewStatusEnum.cancelled: 'cancelled',
};
