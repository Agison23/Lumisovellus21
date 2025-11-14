// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_period.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherPeriod _$WeatherPeriodFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WeatherPeriod', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['start', 'end']);
      final val = WeatherPeriod(
        start: $checkedConvert('start', (v) => DateTime.parse(v as String)),
        end: $checkedConvert('end', (v) => DateTime.parse(v as String)),
      );
      return val;
    });

Map<String, dynamic> _$WeatherPeriodToJson(WeatherPeriod instance) =>
    <String, dynamic>{
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
    };
