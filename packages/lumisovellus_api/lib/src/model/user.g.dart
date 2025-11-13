// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => $checkedCreate('User', json, (
  $checkedConvert,
) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'firstName',
      'lastName',
      'email',
      'role',
      'phoneNumber',
      'lowBattery',
      'createdAt',
      'updatedAt',
    ],
  );
  final val = User(
    id: $checkedConvert('id', (v) => v as String),
    firstName: $checkedConvert('firstName', (v) => v as String),
    lastName: $checkedConvert('lastName', (v) => v as String?),
    email: $checkedConvert('email', (v) => v as String?),
    role: $checkedConvert('role', (v) => v as String),
    phoneNumber: $checkedConvert('phoneNumber', (v) => v as String?),
    lowBattery: $checkedConvert('lowBattery', (v) => v as num),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'role': instance.role,
  'phoneNumber': instance.phoneNumber,
  'lowBattery': instance.lowBattery,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
