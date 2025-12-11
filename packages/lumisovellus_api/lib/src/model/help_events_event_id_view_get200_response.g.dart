// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_events_event_id_view_get200_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelpEventsEventIdViewGet200Response
_$HelpEventsEventIdViewGet200ResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HelpEventsEventIdViewGet200Response', json, (
      $checkedConvert,
    ) {
      $checkKeys(json, requiredKeys: const ['success', 'data', 'meta']);
      final val = HelpEventsEventIdViewGet200Response(
        success: $checkedConvert('success', (v) => v as bool),
        data: $checkedConvert(
          'data',
          (v) => HelpEventsEventIdViewGet200ResponseData.fromJson(
            v as Map<String, dynamic>,
          ),
        ),
        meta: $checkedConvert(
          'meta',
          (v) => HealthGet200ResponseMeta.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$HelpEventsEventIdViewGet200ResponseToJson(
  HelpEventsEventIdViewGet200Response instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.toJson(),
  'meta': instance.meta.toJson(),
};
