// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_secondary_snow_types_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddSecondarySnowTypesRequest _$AddSecondarySnowTypesRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AddSecondarySnowTypesRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['secondarySnowTypeIds']);
  final val = AddSecondarySnowTypesRequest(
    secondarySnowTypeIds: $checkedConvert(
      'secondarySnowTypeIds',
      (v) => (v as List<dynamic>).map((e) => e as String).toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$AddSecondarySnowTypesRequestToJson(
  AddSecondarySnowTypesRequest instance,
) => <String, dynamic>{'secondarySnowTypeIds': instance.secondarySnowTypeIds};
