// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_segments_get200_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiV1SegmentsGet200Response _$ApiV1SegmentsGet200ResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ApiV1SegmentsGet200Response', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['success', 'data', 'meta']);
  final val = ApiV1SegmentsGet200Response(
    success: $checkedConvert('success', (v) => v as bool),
    data: $checkedConvert(
      'data',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => Segment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    ),
    meta: $checkedConvert(
      'meta',
      (v) => HealthGet200ResponseMeta.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$ApiV1SegmentsGet200ResponseToJson(
  ApiV1SegmentsGet200Response instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.map((e) => e.toJson()).toList(),
  'meta': instance.meta.toJson(),
};
