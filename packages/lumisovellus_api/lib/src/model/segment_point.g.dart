// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'segment_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SegmentPoint _$SegmentPointFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SegmentPoint', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['lat', 'lng']);
      final val = SegmentPoint(
        lat: $checkedConvert('lat', (v) => v as num),
        lng: $checkedConvert('lng', (v) => v as num),
      );
      return val;
    });

Map<String, dynamic> _$SegmentPointToJson(SegmentPoint instance) =>
    <String, dynamic>{'lat': instance.lat, 'lng': instance.lng};
