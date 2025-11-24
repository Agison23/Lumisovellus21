// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_events_post201_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelpEventsPost201Response _$HelpEventsPost201ResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('HelpEventsPost201Response', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['success', 'data', 'meta']);
  final val = HelpEventsPost201Response(
    success: $checkedConvert('success', (v) => v as bool),
    data: $checkedConvert(
      'data',
      (v) => HelpEventRescueeView.fromJson(v as Map<String, dynamic>),
    ),
    meta: $checkedConvert(
      'meta',
      (v) => HealthGet200ResponseMeta.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$HelpEventsPost201ResponseToJson(
  HelpEventsPost201Response instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.toJson(),
  'meta': instance.meta.toJson(),
};
