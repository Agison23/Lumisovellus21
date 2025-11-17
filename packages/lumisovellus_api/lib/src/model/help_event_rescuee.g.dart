// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_event_rescuee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelpEventRescuee _$HelpEventRescueeFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HelpEventRescuee', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['userId', 'needType', 'userStatus'],
      );
      final val = HelpEventRescuee(
        userId: $checkedConvert('userId', (v) => v as String),
        needType: $checkedConvert(
          'needType',
          (v) => $enumDecode(_$HelpEventRescueeNeedTypeEnumEnumMap, v),
        ),
        userStatus: $checkedConvert(
          'userStatus',
          (v) => HelpEventUserStatus.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$HelpEventRescueeToJson(HelpEventRescuee instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'needType': _$HelpEventRescueeNeedTypeEnumEnumMap[instance.needType]!,
      'userStatus': instance.userStatus.toJson(),
    };

const _$HelpEventRescueeNeedTypeEnumEnumMap = {
  HelpEventRescueeNeedTypeEnum.health: 'health',
  HelpEventRescueeNeedTypeEnum.equipment: 'equipment',
  HelpEventRescueeNeedTypeEnum.lost: 'lost',
};
