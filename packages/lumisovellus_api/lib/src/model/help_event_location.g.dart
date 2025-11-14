// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_event_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelpEventLocation _$HelpEventLocationFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HelpEventLocation', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['latitude', 'longitude']);
      final val = HelpEventLocation(
        latitude: $checkedConvert('latitude', (v) => v as num),
        longitude: $checkedConvert('longitude', (v) => v as num),
        accuracy: $checkedConvert('accuracy', (v) => v as num?),
      );
      return val;
    });

Map<String, dynamic> _$HelpEventLocationToJson(HelpEventLocation instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'accuracy': ?instance.accuracy,
    };
