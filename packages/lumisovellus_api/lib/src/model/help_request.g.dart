// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelpRequest _$HelpRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HelpRequest', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'timestamp',
          'deviceId',
          'gpsCoord',
          'helpType',
          'chatRoomId',
        ],
      );
      final val = HelpRequest(
        timestamp: $checkedConvert('timestamp', (v) => (v as num).toInt()),
        deviceId: $checkedConvert('deviceId', (v) => v as String),
        gpsCoord: $checkedConvert('gpsCoord', (v) => v as String),
        helpType: $checkedConvert(
          'helpType',
          (v) => $enumDecode(_$HelpRequestHelpTypeEnumEnumMap, v),
        ),
        chatRoomId: $checkedConvert('chatRoomId', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$HelpRequestToJson(HelpRequest instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'deviceId': instance.deviceId,
      'gpsCoord': instance.gpsCoord,
      'helpType': _$HelpRequestHelpTypeEnumEnumMap[instance.helpType]!,
      'chatRoomId': instance.chatRoomId,
    };

const _$HelpRequestHelpTypeEnumEnumMap = {
  HelpRequestHelpTypeEnum.seriousEmerg: 'seriousEmerg',
  HelpRequestHelpTypeEnum.help: 'help',
};
