// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_filter_days_response_matches_inner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherFilterDaysResponseMatchesInner
_$WeatherFilterDaysResponseMatchesInnerFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WeatherFilterDaysResponseMatchesInner', json, (
      $checkedConvert,
    ) {
      $checkKeys(json, requiredKeys: const ['date', 'averageTemperature']);
      final val = WeatherFilterDaysResponseMatchesInner(
        date: $checkedConvert('date', (v) => DateTime.parse(v as String)),
        averageTemperature: $checkedConvert(
          'averageTemperature',
          (v) => v as num,
        ),
      );
      return val;
    });

Map<String, dynamic> _$WeatherFilterDaysResponseMatchesInnerToJson(
  WeatherFilterDaysResponseMatchesInner instance,
) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'averageTemperature': instance.averageTemperature,
};
