// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_event_location_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelpEventLocationOutput _$HelpEventLocationOutputFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('HelpEventLocationOutput', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['latitude', 'longitude']);
  final val = HelpEventLocationOutput(
    latitude: $checkedConvert('latitude', (v) => v as num),
    longitude: $checkedConvert('longitude', (v) => v as num),
    accuracy: $checkedConvert('accuracy', (v) => v as num?),
  );
  return val;
});

Map<String, dynamic> _$HelpEventLocationOutputToJson(
  HelpEventLocationOutput instance,
) => <String, dynamic>{
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'accuracy': ?instance.accuracy,
};
