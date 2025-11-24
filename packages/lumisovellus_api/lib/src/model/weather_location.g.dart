// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherLocation _$WeatherLocationFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WeatherLocation', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['name', 'latitude', 'longitude']);
      final val = WeatherLocation(
        name: $checkedConvert('name', (v) => v as String),
        latitude: $checkedConvert('latitude', (v) => v as num),
        longitude: $checkedConvert('longitude', (v) => v as num),
      );
      return val;
    });

Map<String, dynamic> _$WeatherLocationToJson(WeatherLocation instance) =>
    <String, dynamic>{
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
