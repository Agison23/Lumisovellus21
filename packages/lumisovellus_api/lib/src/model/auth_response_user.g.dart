// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponseUser _$AuthResponseUserFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AuthResponseUser', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['id', 'firstName', 'lastName', 'email', 'role'],
      );
      final val = AuthResponseUser(
        id: $checkedConvert('id', (v) => v as String),
        firstName: $checkedConvert('firstName', (v) => v as String),
        lastName: $checkedConvert('lastName', (v) => v as String?),
        email: $checkedConvert('email', (v) => v as String?),
        role: $checkedConvert('role', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AuthResponseUserToJson(AuthResponseUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'role': instance.role,
    };
