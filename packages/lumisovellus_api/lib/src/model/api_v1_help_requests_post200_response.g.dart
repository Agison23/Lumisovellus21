// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_help_requests_post200_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiV1HelpRequestsPost200Response _$ApiV1HelpRequestsPost200ResponseFromJson(
  Map<String, dynamic> json,
) =>
    $checkedCreate('ApiV1HelpRequestsPost200Response', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['success', 'data', 'meta']);
      final val = ApiV1HelpRequestsPost200Response(
        success: $checkedConvert('success', (v) => v as bool),
        data: $checkedConvert(
          'data',
          (v) => ApiV1HelpRequestsPost200ResponseData.fromJson(
            v as Map<String, dynamic>,
          ),
        ),
        meta: $checkedConvert(
          'meta',
          (v) => HealthGet200ResponseMeta.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ApiV1HelpRequestsPost200ResponseToJson(
  ApiV1HelpRequestsPost200Response instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.toJson(),
  'meta': instance.meta.toJson(),
};
