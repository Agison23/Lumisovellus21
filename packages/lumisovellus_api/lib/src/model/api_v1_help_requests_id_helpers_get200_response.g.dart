// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_help_requests_id_helpers_get200_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiV1HelpRequestsIdHelpersGet200Response
_$ApiV1HelpRequestsIdHelpersGet200ResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ApiV1HelpRequestsIdHelpersGet200Response', json, (
  $checkedConvert,
) {
  $checkKeys(json, requiredKeys: const ['success', 'data', 'meta']);
  final val = ApiV1HelpRequestsIdHelpersGet200Response(
    success: $checkedConvert('success', (v) => v as bool),
    data: $checkedConvert(
      'data',
      (v) =>
          (v as List<dynamic>?)
              ?.map(
                (e) =>
                    ApiV1HelpRequestsIdHelpersGet200ResponseDataInner.fromJson(
                      e as Map<String, dynamic>,
                    ),
              )
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

Map<String, dynamic> _$ApiV1HelpRequestsIdHelpersGet200ResponseToJson(
  ApiV1HelpRequestsIdHelpersGet200Response instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.map((e) => e.toJson()).toList(),
  'meta': instance.meta.toJson(),
};
