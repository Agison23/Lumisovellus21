// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_reset_password_post200_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResetPasswordPost200Response _$AuthResetPasswordPost200ResponseFromJson(
  Map<String, dynamic> json,
) =>
    $checkedCreate('AuthResetPasswordPost200Response', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['success', 'data', 'meta']);
      final val = AuthResetPasswordPost200Response(
        success: $checkedConvert('success', (v) => v as bool),
        data: $checkedConvert(
          'data',
          (v) => AuthResetPasswordPost200ResponseData.fromJson(
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

Map<String, dynamic> _$AuthResetPasswordPost200ResponseToJson(
  AuthResetPasswordPost200Response instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.toJson(),
  'meta': instance.meta.toJson(),
};
