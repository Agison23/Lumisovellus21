// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_help_requests_post200_response_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiV1HelpRequestsPost200ResponseData
_$ApiV1HelpRequestsPost200ResponseDataFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ApiV1HelpRequestsPost200ResponseData', json, (
      $checkedConvert,
    ) {
      $checkKeys(json, requiredKeys: const ['status', 'nearbyUsers']);
      final val = ApiV1HelpRequestsPost200ResponseData(
        status: $checkedConvert('status', (v) => v as String),
        nearbyUsers: $checkedConvert('nearbyUsers', (v) => v as num),
      );
      return val;
    });

Map<String, dynamic> _$ApiV1HelpRequestsPost200ResponseDataToJson(
  ApiV1HelpRequestsPost200ResponseData instance,
) => <String, dynamic>{
  'status': instance.status,
  'nearbyUsers': instance.nearbyUsers,
};
