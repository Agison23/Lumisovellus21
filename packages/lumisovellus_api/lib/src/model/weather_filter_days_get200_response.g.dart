// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_filter_days_get200_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherFilterDaysGet200Response _$WeatherFilterDaysGet200ResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('WeatherFilterDaysGet200Response', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['success', 'data', 'meta']);
  final val = WeatherFilterDaysGet200Response(
    success: $checkedConvert('success', (v) => v as bool),
    data: $checkedConvert(
      'data',
      (v) => WeatherFilterDaysResponse.fromJson(v as Map<String, dynamic>),
    ),
    meta: $checkedConvert(
      'meta',
      (v) => HealthGet200ResponseMeta.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$WeatherFilterDaysGet200ResponseToJson(
  WeatherFilterDaysGet200Response instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.toJson(),
  'meta': instance.meta.toJson(),
};
