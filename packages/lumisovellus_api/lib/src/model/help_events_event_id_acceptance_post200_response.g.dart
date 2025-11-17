// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_events_event_id_acceptance_post200_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelpEventsEventIdAcceptancePost200Response
_$HelpEventsEventIdAcceptancePost200ResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('HelpEventsEventIdAcceptancePost200Response', json, (
  $checkedConvert,
) {
  $checkKeys(json, requiredKeys: const ['success', 'data', 'meta']);
  final val = HelpEventsEventIdAcceptancePost200Response(
    success: $checkedConvert('success', (v) => v as bool),
    data: $checkedConvert(
      'data',
      (v) => HelpEventRescuerView.fromJson(v as Map<String, dynamic>),
    ),
    meta: $checkedConvert(
      'meta',
      (v) => HealthGet200ResponseMeta.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$HelpEventsEventIdAcceptancePost200ResponseToJson(
  HelpEventsEventIdAcceptancePost200Response instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.toJson(),
  'meta': instance.meta.toJson(),
};
