// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponse _$ErrorResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ErrorResponse', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['success', 'error', 'meta']);
      final val = ErrorResponse(
        success: $checkedConvert('success', (v) => v as bool),
        error: $checkedConvert(
          'error',
          (v) => ErrorResponseError.fromJson(v as Map<String, dynamic>),
        ),
        meta: $checkedConvert(
          'meta',
          (v) => ErrorResponseMeta.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error.toJson(),
      'meta': instance.meta.toJson(),
    };
