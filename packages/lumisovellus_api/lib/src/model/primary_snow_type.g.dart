// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'primary_snow_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrimarySnowType _$PrimarySnowTypeFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PrimarySnowType', json, ($checkedConvert) {
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
          'secondaryTypes',
        ],
      );
      final val = PrimarySnowType(
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
        secondaryTypes: $checkedConvert(
          'secondaryTypes',
          (v) =>
              (v as List<dynamic>?)
                  ?.map((e) => SnowType.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              const [],
        ),
      );
      return val;
    });

Map<String, dynamic> _$PrimarySnowTypeToJson(PrimarySnowType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'identifier': instance.identifier,
      'name': instance.name,
      'colour': instance.colour,
      'skiability': instance.skiability,
      'primarySnowTypeId': instance.primarySnowTypeId,
      'explanation': instance.explanation,
      'secondaryTypes': instance.secondaryTypes.map((e) => e.toJson()).toList(),
    };
