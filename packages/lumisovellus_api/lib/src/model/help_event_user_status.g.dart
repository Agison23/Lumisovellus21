// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_event_user_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelpEventUserStatus _$HelpEventUserStatusFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HelpEventUserStatus', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['location', 'batteryLevel']);
      final val = HelpEventUserStatus(
        location: $checkedConvert(
          'location',
          (v) => HelpEventLocationOutput.fromJson(v as Map<String, dynamic>),
        ),
        batteryLevel: $checkedConvert(
          'batteryLevel',
          (v) => (v as num?)?.toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$HelpEventUserStatusToJson(
  HelpEventUserStatus instance,
) => <String, dynamic>{
  'location': instance.location.toJson(),
  'batteryLevel': instance.batteryLevel,
};
