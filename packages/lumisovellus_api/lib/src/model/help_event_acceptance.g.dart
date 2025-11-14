// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_event_acceptance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelpEventAcceptance _$HelpEventAcceptanceFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HelpEventAcceptance', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['location']);
      final val = HelpEventAcceptance(
        location: $checkedConvert(
          'location',
          (v) => HelpEventLocation.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$HelpEventAcceptanceToJson(
  HelpEventAcceptance instance,
) => <String, dynamic>{'location': instance.location.toJson()};
