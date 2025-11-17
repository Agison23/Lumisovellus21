// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_filter_days_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherFilterDaysResponse _$WeatherFilterDaysResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('WeatherFilterDaysResponse', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'item',
      'threshold',
      'days',
      'period',
      'location',
      'matches',
    ],
  );
  final val = WeatherFilterDaysResponse(
    item: $checkedConvert(
      'item',
      (v) => $enumDecode(_$WeatherFilterDaysResponseItemEnumEnumMap, v),
    ),
    threshold: $checkedConvert('threshold', (v) => v as num),
    days: $checkedConvert('days', (v) => (v as num).toInt()),
    period: $checkedConvert(
      'period',
      (v) => WeatherPeriod.fromJson(v as Map<String, dynamic>),
    ),
    location: $checkedConvert(
      'location',
      (v) => WeatherLocation.fromJson(v as Map<String, dynamic>),
    ),
    matches: $checkedConvert(
      'matches',
      (v) =>
          (v as List<dynamic>?)
              ?.map(
                (e) => WeatherFilterDaysResponseMatchesInner.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
    ),
  );
  return val;
});

Map<String, dynamic> _$WeatherFilterDaysResponseToJson(
  WeatherFilterDaysResponse instance,
) => <String, dynamic>{
  'item': _$WeatherFilterDaysResponseItemEnumEnumMap[instance.item]!,
  'threshold': instance.threshold,
  'days': instance.days,
  'period': instance.period.toJson(),
  'location': instance.location.toJson(),
  'matches': instance.matches.map((e) => e.toJson()).toList(),
};

const _$WeatherFilterDaysResponseItemEnumEnumMap = {
  WeatherFilterDaysResponseItemEnum.temperature: 'temperature',
};
