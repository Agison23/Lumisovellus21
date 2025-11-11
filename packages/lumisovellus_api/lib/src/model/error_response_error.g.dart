// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_response_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponseError _$ErrorResponseErrorFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ErrorResponseError', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['code', 'message']);
      final val = ErrorResponseError(
        code: $checkedConvert('code', (v) => v as String),
        message: $checkedConvert('message', (v) => v as String),
        details: $checkedConvert('details', (v) => v),
      );
      return val;
    });

Map<String, dynamic> _$ErrorResponseErrorToJson(ErrorResponseError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'details': ?instance.details,
    };
