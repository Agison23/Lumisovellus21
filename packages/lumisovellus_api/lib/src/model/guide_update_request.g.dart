// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guide_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GuideUpdateRequest _$GuideUpdateRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GuideUpdateRequest', json, ($checkedConvert) {
      final val = GuideUpdateRequest(
        description: $checkedConvert('description', (v) => v as String?),
        primarySnowTypeIds: $checkedConvert(
          'primarySnowTypeIds',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
        ),
        secondarySnowTypeIds: $checkedConvert(
          'secondarySnowTypeIds',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
        ),
        hazards: $checkedConvert(
          'hazards',
          (v) =>
              (v as List<dynamic>?)
                  ?.map((e) => $enumDecode(_$HazardEnumMap, e))
                  .toList() ??
              [],
        ),
      );
      return val;
    });

Map<String, dynamic> _$GuideUpdateRequestToJson(GuideUpdateRequest instance) =>
    <String, dynamic>{
      'description': ?instance.description,
      'primarySnowTypeIds': ?instance.primarySnowTypeIds,
      'secondarySnowTypeIds': ?instance.secondarySnowTypeIds,
      'hazards': ?instance.hazards?.map((e) => _$HazardEnumMap[e]!).toList(),
    };

const _$HazardEnumMap = {Hazard.stones: 'stones', Hazard.branches: 'branches'};
