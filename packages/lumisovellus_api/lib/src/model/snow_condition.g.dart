// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snow_condition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SnowCondition _$SnowConditionFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SnowCondition', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'snowType',
          'secondarySnowType',
          'layer',
          'depth',
          'coverage',
          'quality',
          'hardness',
          'moisture',
          'notes',
          'createdAt',
        ],
      );
      final val = SnowCondition(
        id: $checkedConvert('id', (v) => v as String),
        snowType: $checkedConvert('snowType', (v) => v as String?),
        secondarySnowType: $checkedConvert(
          'secondarySnowType',
          (v) => v as String?,
        ),
        layer: $checkedConvert(
          'layer',
          (v) => $enumDecode(_$SnowConditionLayerEnumEnumMap, v),
        ),
        depth: $checkedConvert('depth', (v) => v as num?),
        coverage: $checkedConvert('coverage', (v) => v as num?),
        quality: $checkedConvert('quality', (v) => v as num?),
        hardness: $checkedConvert('hardness', (v) => v as num?),
        moisture: $checkedConvert('moisture', (v) => v as num?),
        notes: $checkedConvert('notes', (v) => v as String?),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$SnowConditionToJson(SnowCondition instance) =>
    <String, dynamic>{
      'id': instance.id,
      'snowType': instance.snowType,
      'secondarySnowType': instance.secondarySnowType,
      'layer': _$SnowConditionLayerEnumEnumMap[instance.layer]!,
      'depth': instance.depth,
      'coverage': instance.coverage,
      'quality': instance.quality,
      'hardness': instance.hardness,
      'moisture': instance.moisture,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$SnowConditionLayerEnumEnumMap = {
  SnowConditionLayerEnum.SURFACE: 'SURFACE',
  SnowConditionLayerEnum.MIDDLE: 'MIDDLE',
  SnowConditionLayerEnum.BASE: 'BASE',
};
