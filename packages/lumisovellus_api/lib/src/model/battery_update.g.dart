// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'battery_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BatteryUpdate _$BatteryUpdateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BatteryUpdate', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['batteryStatus']);
      final val = BatteryUpdate(
        batteryStatus: $checkedConvert(
          'batteryStatus',
          (v) => $enumDecode(_$BatteryUpdateBatteryStatusEnumEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$BatteryUpdateToJson(BatteryUpdate instance) =>
    <String, dynamic>{
      'batteryStatus':
          _$BatteryUpdateBatteryStatusEnumEnumMap[instance.batteryStatus]!,
    };

const _$BatteryUpdateBatteryStatusEnumEnumMap = {
  BatteryUpdateBatteryStatusEnum.low: 'low',
  BatteryUpdateBatteryStatusEnum.normal: 'normal',
};
