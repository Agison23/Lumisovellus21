// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_help_requests_id_helpers_get200_response_data_inner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiV1HelpRequestsIdHelpersGet200ResponseDataInner
_$ApiV1HelpRequestsIdHelpersGet200ResponseDataInnerFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ApiV1HelpRequestsIdHelpersGet200ResponseDataInner', json, (
  $checkedConvert,
) {
  $checkKeys(
    json,
    requiredKeys: const [
      'userId',
      'firstName',
      'lastName',
      'phoneNumber',
      'distance',
      'state',
      'lowBattery',
      'lastSeen',
    ],
  );
  final val = ApiV1HelpRequestsIdHelpersGet200ResponseDataInner(
    userId: $checkedConvert('userId', (v) => v as String),
    firstName: $checkedConvert('firstName', (v) => v as String),
    lastName: $checkedConvert('lastName', (v) => v as String?),
    phoneNumber: $checkedConvert('phoneNumber', (v) => v as String?),
    distance: $checkedConvert('distance', (v) => v as num),
    state: $checkedConvert('state', (v) => v as num),
    lowBattery: $checkedConvert('lowBattery', (v) => v as num),
    lastSeen: $checkedConvert('lastSeen', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$ApiV1HelpRequestsIdHelpersGet200ResponseDataInnerToJson(
  ApiV1HelpRequestsIdHelpersGet200ResponseDataInner instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'phoneNumber': instance.phoneNumber,
  'distance': instance.distance,
  'state': instance.state,
  'lowBattery': instance.lowBattery,
  'lastSeen': instance.lastSeen.toIso8601String(),
};
