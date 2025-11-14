// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_get200_response_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthGet200ResponseMeta _$HealthGet200ResponseMetaFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('HealthGet200ResponseMeta', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['timestamp']);
  final val = HealthGet200ResponseMeta(
    timestamp: $checkedConvert('timestamp', (v) => DateTime.parse(v as String)),
    message: $checkedConvert('message', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$HealthGet200ResponseMetaToJson(
  HealthGet200ResponseMeta instance,
) => <String, dynamic>{
  'timestamp': instance.timestamp.toIso8601String(),
  'message': ?instance.message,
};
