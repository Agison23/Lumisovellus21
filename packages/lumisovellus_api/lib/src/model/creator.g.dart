// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'creator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Creator _$CreatorFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Creator', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['firstName', 'lastName']);
      final val = Creator(
        firstName: $checkedConvert('firstName', (v) => v as String?),
        lastName: $checkedConvert('lastName', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$CreatorToJson(Creator instance) => <String, dynamic>{
  'firstName': instance.firstName,
  'lastName': instance.lastName,
};
