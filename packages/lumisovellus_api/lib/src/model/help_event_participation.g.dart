// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_event_participation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelpEventParticipation _$HelpEventParticipationFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('HelpEventParticipation', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'acceptanceId',
      'eventId',
      'responderId',
      'location',
      'acceptedAt',
    ],
  );
  final val = HelpEventParticipation(
    acceptanceId: $checkedConvert('acceptanceId', (v) => v as String),
    eventId: $checkedConvert('eventId', (v) => v as String),
    responderId: $checkedConvert('responderId', (v) => v as String),
    location: $checkedConvert(
      'location',
      (v) => v == null
          ? null
          : HelpEventLocationOutput.fromJson(v as Map<String, dynamic>),
    ),
    acceptedAt: $checkedConvert(
      'acceptedAt',
      (v) => DateTime.parse(v as String),
    ),
  );
  return val;
});

Map<String, dynamic> _$HelpEventParticipationToJson(
  HelpEventParticipation instance,
) => <String, dynamic>{
  'acceptanceId': instance.acceptanceId,
  'eventId': instance.eventId,
  'responderId': instance.responderId,
  'location': instance.location?.toJson(),
  'acceptedAt': instance.acceptedAt.toIso8601String(),
};
