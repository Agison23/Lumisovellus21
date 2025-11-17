// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_segments_id_observations_get200_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiV1SegmentsIdObservationsGet200Response
_$ApiV1SegmentsIdObservationsGet200ResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ApiV1SegmentsIdObservationsGet200Response', json, (
  $checkedConvert,
) {
  $checkKeys(json, requiredKeys: const ['success', 'data', 'meta']);
  final val = ApiV1SegmentsIdObservationsGet200Response(
    success: $checkedConvert('success', (v) => v as bool),
    data: $checkedConvert(
      'data',
      (v) => Observation.fromJson(v as Map<String, dynamic>),
    ),
    meta: $checkedConvert(
      'meta',
      (v) => HealthGet200ResponseMeta.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$ApiV1SegmentsIdObservationsGet200ResponseToJson(
  ApiV1SegmentsIdObservationsGet200Response instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.toJson(),
  'meta': instance.meta.toJson(),
};
