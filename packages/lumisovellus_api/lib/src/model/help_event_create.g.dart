// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_event_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelpEventCreate _$HelpEventCreateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HelpEventCreate', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['timestamp', 'location', 'needType', 'chatRoomId'],
      );
      final val = HelpEventCreate(
        timestamp: $checkedConvert('timestamp', (v) => (v as num).toInt()),
        location: $checkedConvert(
          'location',
          (v) => HelpEventLocation.fromJson(v as Map<String, dynamic>),
        ),
        needType: $checkedConvert(
          'needType',
          (v) => $enumDecode(_$HelpEventCreateNeedTypeEnumEnumMap, v),
        ),
        chatRoomId: $checkedConvert('chatRoomId', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$HelpEventCreateToJson(HelpEventCreate instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'location': instance.location.toJson(),
      'needType': _$HelpEventCreateNeedTypeEnumEnumMap[instance.needType]!,
      'chatRoomId': instance.chatRoomId,
    };

const _$HelpEventCreateNeedTypeEnumEnumMap = {
  HelpEventCreateNeedTypeEnum.health: 'health',
  HelpEventCreateNeedTypeEnum.equipment: 'equipment',
  HelpEventCreateNeedTypeEnum.lost: 'lost',
};
