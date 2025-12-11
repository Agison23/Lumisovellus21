// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AuthResponse', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['user', 'accessToken', 'refreshToken'],
      );
      final val = AuthResponse(
        user: $checkedConvert(
          'user',
          (v) => AuthResponseUser.fromJson(v as Map<String, dynamic>),
        ),
        accessToken: $checkedConvert('accessToken', (v) => v as String),
        refreshToken: $checkedConvert('refreshToken', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };
