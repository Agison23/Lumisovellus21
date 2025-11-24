// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_response_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponseMeta _$ErrorResponseMetaFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ErrorResponseMeta', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['timestamp']);
      final val = ErrorResponseMeta(
        timestamp: $checkedConvert(
          'timestamp',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ErrorResponseMetaToJson(ErrorResponseMeta instance) =>
    <String, dynamic>{'timestamp': instance.timestamp.toIso8601String()};
