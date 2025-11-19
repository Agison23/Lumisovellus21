// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_events_nearby_get200_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelpEventsNearbyGet200Response _$HelpEventsNearbyGet200ResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('HelpEventsNearbyGet200Response', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['success', 'data', 'meta']);
  final val = HelpEventsNearbyGet200Response(
    success: $checkedConvert('success', (v) => v as bool),
    data: $checkedConvert(
      'data',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => HelpEventSummary.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    ),
    meta: $checkedConvert(
      'meta',
      (v) => HealthGet200ResponseMeta.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$HelpEventsNearbyGet200ResponseToJson(
  HelpEventsNearbyGet200Response instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.map((e) => e.toJson()).toList(),
  'meta': instance.meta.toJson(),
};
