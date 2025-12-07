// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_metric.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherMetric _$WeatherMetricFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WeatherMetric', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'type',
          'item',
          'value',
          'unit',
          'days',
          'period',
          'location',
        ],
      );
      final val = WeatherMetric(
        type: $checkedConvert(
          'type',
          (v) => $enumDecode(_$WeatherMetricTypeEnumEnumMap, v),
        ),
        item: $checkedConvert('item', (v) => v as String),
        value: $checkedConvert('value', (v) => v as num),
        unit: $checkedConvert('unit', (v) => v as String),
        days: $checkedConvert('days', (v) => (v as num).toInt()),
        period: $checkedConvert(
          'period',
          (v) => WeatherPeriod.fromJson(v as Map<String, dynamic>),
        ),
        location: $checkedConvert(
          'location',
          (v) => WeatherLocation.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$WeatherMetricToJson(WeatherMetric instance) =>
    <String, dynamic>{
      'type': _$WeatherMetricTypeEnumEnumMap[instance.type]!,
      'item': instance.item,
      'value': instance.value,
      'unit': instance.unit,
      'days': instance.days,
      'period': instance.period.toJson(),
      'location': instance.location.toJson(),
    };

const _$WeatherMetricTypeEnumEnumMap = {
  WeatherMetricTypeEnum.average: 'average',
  WeatherMetricTypeEnum.minimum: 'minimum',
  WeatherMetricTypeEnum.maximum: 'maximum',
  WeatherMetricTypeEnum.change: 'change',
};
