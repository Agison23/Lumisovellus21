// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_snow_type_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateSnowTypeRequest _$CreateSnowTypeRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('CreateSnowTypeRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['name', 'colour']);
  final val = CreateSnowTypeRequest(
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

Map<String, dynamic> _$CreateSnowTypeRequestToJson(
  CreateSnowTypeRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'colour': instance.colour,
  'skiability': ?instance.skiability,
  'primarySnowTypeId': ?instance.primarySnowTypeId,
  'explanation': ?instance.explanation,
};
