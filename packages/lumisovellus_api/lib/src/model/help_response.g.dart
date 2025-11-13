// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelpResponse _$HelpResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HelpResponse', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['helpGiver', 'helpRequester', 'state'],
      );
      final val = HelpResponse(
        helpGiver: $checkedConvert('helpGiver', (v) => v as String),
        helpRequester: $checkedConvert('helpRequester', (v) => v as String),
        state: $checkedConvert('state', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$HelpResponseToJson(HelpResponse instance) =>
    <String, dynamic>{
      'helpGiver': instance.helpGiver,
      'helpRequester': instance.helpRequester,
      'state': instance.state,
    };
