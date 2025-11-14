// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationUpdate _$LocationUpdateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LocationUpdate', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['timestamp', 'firstName', 'gpsCoord'],
      );
      final val = LocationUpdate(
        timestamp: $checkedConvert('timestamp', (v) => (v as num).toInt()),
        firstName: $checkedConvert('firstName', (v) => v as String),
        lastName: $checkedConvert('lastName', (v) => v as String?),
        gpsCoord: $checkedConvert('gpsCoord', (v) => v as String),
        phoneNumber: $checkedConvert('phoneNumber', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$LocationUpdateToJson(LocationUpdate instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'firstName': instance.firstName,
      'lastName': ?instance.lastName,
      'gpsCoord': instance.gpsCoord,
      'phoneNumber': ?instance.phoneNumber,
    };
