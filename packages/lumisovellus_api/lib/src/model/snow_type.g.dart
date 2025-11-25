// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snow_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SnowType _$SnowTypeFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SnowType', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'identifier',
          'name',
          'colour',
          'skiability',
          'primarySnowTypeId',
          'explanation',
        ],
      );
      final val = SnowType(
        id: $checkedConvert('id', (v) => v as String),
        identifier: $checkedConvert('identifier', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        colour: $checkedConvert('colour', (v) => v as String),
        skiability: $checkedConvert('skiability', (v) => (v as num?)?.toInt()),
        primarySnowTypeId: $checkedConvert(
          'primarySnowTypeId',
          (v) => v as String?,
        ),
        explanation: $checkedConvert('explanation', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$SnowTypeToJson(SnowType instance) => <String, dynamic>{
  'id': instance.id,
  'identifier': instance.identifier,
  'name': instance.name,
  'colour': instance.colour,
  'skiability': instance.skiability,
  'primarySnowTypeId': instance.primarySnowTypeId,
  'explanation': instance.explanation,
};
