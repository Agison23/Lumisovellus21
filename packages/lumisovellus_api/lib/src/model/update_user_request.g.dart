// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateUserRequest _$UpdateUserRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UpdateUserRequest', json, ($checkedConvert) {
      final val = UpdateUserRequest(
        firstName: $checkedConvert('firstName', (v) => v as String?),
        lastName: $checkedConvert('lastName', (v) => v as String?),
        email: $checkedConvert('email', (v) => v as String?),
        role: $checkedConvert(
          'role',
          (v) => $enumDecodeNullable(_$UpdateUserRequestRoleEnumEnumMap, v),
        ),
        phoneNumber: $checkedConvert('phoneNumber', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$UpdateUserRequestToJson(UpdateUserRequest instance) =>
    <String, dynamic>{
      'firstName': ?instance.firstName,
      'lastName': ?instance.lastName,
      'email': ?instance.email,
      'role': ?_$UpdateUserRequestRoleEnumEnumMap[instance.role],
      'phoneNumber': ?instance.phoneNumber,
    };

const _$UpdateUserRequestRoleEnumEnumMap = {
  UpdateUserRequestRoleEnum.NORMAL: 'NORMAL',
  UpdateUserRequestRoleEnum.PREMIUM: 'PREMIUM',
  UpdateUserRequestRoleEnum.ADMIN: 'ADMIN',
  UpdateUserRequestRoleEnum.RESCUE: 'RESCUE',
  UpdateUserRequestRoleEnum.GUIDE: 'GUIDE',
};
