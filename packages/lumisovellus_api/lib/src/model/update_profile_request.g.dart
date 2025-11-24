// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateProfileRequest _$UpdateProfileRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('UpdateProfileRequest', json, ($checkedConvert) {
  final val = UpdateProfileRequest(
    firstName: $checkedConvert('firstName', (v) => v as String?),
    lastName: $checkedConvert('lastName', (v) => v as String?),
    email: $checkedConvert('email', (v) => v as String?),
    phoneNumber: $checkedConvert('phoneNumber', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$UpdateProfileRequestToJson(
  UpdateProfileRequest instance,
) => <String, dynamic>{
  'firstName': ?instance.firstName,
  'lastName': ?instance.lastName,
  'email': ?instance.email,
  'phoneNumber': ?instance.phoneNumber,
};
