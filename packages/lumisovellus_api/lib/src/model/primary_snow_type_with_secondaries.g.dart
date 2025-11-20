// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'primary_snow_type_with_secondaries.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrimarySnowTypeWithSecondaries _$PrimarySnowTypeWithSecondariesFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PrimarySnowTypeWithSecondaries', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'name', 'colour', 'secondarySnowTypes'],
  );
  final val = PrimarySnowTypeWithSecondaries(
    id: $checkedConvert('id', (v) => v as String),
    name: $checkedConvert('name', (v) => v as String),
    colour: $checkedConvert('colour', (v) => v as String),
    skiability: $checkedConvert('skiability', (v) => (v as num?)?.toInt()),
    primarySnowTypeId: $checkedConvert(
      'primarySnowTypeId',
      (v) => v as String?,
    ),
    explanation: $checkedConvert('explanation', (v) => v as String?),
    secondarySnowTypes: $checkedConvert(
      'secondarySnowTypes',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => SnowType.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    ),
  );
  return val;
});

Map<String, dynamic> _$PrimarySnowTypeWithSecondariesToJson(
  PrimarySnowTypeWithSecondaries instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'colour': instance.colour,
  'skiability': ?instance.skiability,
  'primarySnowTypeId': ?instance.primarySnowTypeId,
  'explanation': ?instance.explanation,
  'secondarySnowTypes': instance.secondarySnowTypes
      .map((e) => e.toJson())
      .toList(),
};
