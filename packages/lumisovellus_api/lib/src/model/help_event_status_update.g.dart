// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_event_status_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelpEventStatusUpdate _$HelpEventStatusUpdateFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('HelpEventStatusUpdate', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['status']);
  final val = HelpEventStatusUpdate(
    status: $checkedConvert(
      'status',
      (v) => $enumDecode(_$HelpEventStatusUpdateStatusEnumEnumMap, v),
    ),
  );
  return val;
});

Map<String, dynamic> _$HelpEventStatusUpdateToJson(
  HelpEventStatusUpdate instance,
) => <String, dynamic>{
  'status': _$HelpEventStatusUpdateStatusEnumEnumMap[instance.status]!,
};

const _$HelpEventStatusUpdateStatusEnumEnumMap = {
  HelpEventStatusUpdateStatusEnum.active: 'active',
  HelpEventStatusUpdateStatusEnum.completed: 'completed',
  HelpEventStatusUpdateStatusEnum.cancelled: 'cancelled',
};
