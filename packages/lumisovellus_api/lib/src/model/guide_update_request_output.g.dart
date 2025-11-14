// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guide_update_request_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GuideUpdateRequestOutput _$GuideUpdateRequestOutputFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('GuideUpdateRequestOutput', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['primarySnowTypeIds', 'secondarySnowTypeIds'],
  );
  final val = GuideUpdateRequestOutput(
    description: $checkedConvert('description', (v) => v as String?),
    primarySnowTypeIds: $checkedConvert(
      'primarySnowTypeIds',
      (v) => (v as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    ),
    secondarySnowTypeIds: $checkedConvert(
      'secondarySnowTypeIds',
      (v) => (v as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    ),
  );
  return val;
});

Map<String, dynamic> _$GuideUpdateRequestOutputToJson(
  GuideUpdateRequestOutput instance,
) => <String, dynamic>{
  'description': ?instance.description,
  'primarySnowTypeIds': instance.primarySnowTypeIds,
  'secondarySnowTypeIds': instance.secondarySnowTypeIds,
};
