// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_users_id_put_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiV1UsersIdPutRequest _$ApiV1UsersIdPutRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ApiV1UsersIdPutRequest', json, ($checkedConvert) {
  final val = ApiV1UsersIdPutRequest(
    firstName: $checkedConvert('firstName', (v) => v as String?),
    lastName: $checkedConvert('lastName', (v) => v as String?),
    email: $checkedConvert('email', (v) => v as String?),
    phoneNumber: $checkedConvert('phoneNumber', (v) => v as String?),
    role: $checkedConvert('role', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$ApiV1UsersIdPutRequestToJson(
  ApiV1UsersIdPutRequest instance,
) => <String, dynamic>{
  'firstName': ?instance.firstName,
  'lastName': ?instance.lastName,
  'email': ?instance.email,
  'phoneNumber': ?instance.phoneNumber,
  'role': ?instance.role,
};
