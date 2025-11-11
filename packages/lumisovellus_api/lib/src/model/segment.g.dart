// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'segment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Segment _$SegmentFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Segment', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'name',
          'terrain',
          'avalancheDanger',
          'isLowerSegment',
          'points',
          'guideUpdate',
          'userReviews',
        ],
      );
      final val = Segment(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        terrain: $checkedConvert('terrain', (v) => v as String),
        avalancheDanger: $checkedConvert('avalancheDanger', (v) => v as bool),
        isLowerSegment: $checkedConvert(
          'isLowerSegment',
          (v) => (v as num?)?.toInt(),
        ),
        points: $checkedConvert(
          'points',
          (v) => (v as List<dynamic>)
              .map((e) => SegmentPoint.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        guideUpdate: $checkedConvert(
          'guideUpdate',
          (v) => v == null
              ? null
              : GuideUpdateRequestOutput.fromJson(v as Map<String, dynamic>),
        ),
        userReviews: $checkedConvert(
          'userReviews',
          (v) => (v as List<dynamic>)
              .map((e) => SegmentUserReview.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$SegmentToJson(Segment instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'terrain': instance.terrain,
  'avalancheDanger': instance.avalancheDanger,
  'isLowerSegment': instance.isLowerSegment,
  'points': instance.points.map((e) => e.toJson()).toList(),
  'guideUpdate': instance.guideUpdate?.toJson(),
  'userReviews': instance.userReviews.map((e) => e.toJson()).toList(),
};
