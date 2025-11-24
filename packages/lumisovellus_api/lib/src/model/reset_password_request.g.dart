// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetPasswordRequest _$ResetPasswordRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ResetPasswordRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['email']);
  final val = ResetPasswordRequest(
    email: $checkedConvert('email', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$ResetPasswordRequestToJson(
  ResetPasswordRequest instance,
) => <String, dynamic>{'email': instance.email};
