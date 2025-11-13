// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoleUpdate _$RoleUpdateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RoleUpdate', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['role']);
      final val = RoleUpdate(role: $checkedConvert('role', (v) => v as String));
      return val;
    });

Map<String, dynamic> _$RoleUpdateToJson(RoleUpdate instance) =>
    <String, dynamic>{'role': instance.role};
