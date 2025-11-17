// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_average_get200_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherAverageGet200Response _$WeatherAverageGet200ResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('WeatherAverageGet200Response', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['success', 'data', 'meta']);
  final val = WeatherAverageGet200Response(
    success: $checkedConvert('success', (v) => v as bool),
    data: $checkedConvert(
      'data',
      (v) => WeatherMetric.fromJson(v as Map<String, dynamic>),
    ),
    meta: $checkedConvert(
      'meta',
      (v) => HealthGet200ResponseMeta.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$WeatherAverageGet200ResponseToJson(
  WeatherAverageGet200Response instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.toJson(),
  'meta': instance.meta.toJson(),
};
