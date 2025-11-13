// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewReference _$ReviewReferenceFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ReviewReference', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'updateId',
          'reviewId',
          'relevance',
          'notes',
          'createdAt',
          'reviewRel',
        ],
      );
      final val = ReviewReference(
        id: $checkedConvert('id', (v) => v as String),
        updateId: $checkedConvert('updateId', (v) => v as String),
        reviewId: $checkedConvert('reviewId', (v) => v as String),
        relevance: $checkedConvert('relevance', (v) => (v as num).toInt()),
        notes: $checkedConvert('notes', (v) => v as String?),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
        reviewRel: $checkedConvert(
          'reviewRel',
          (v) => ReviewReferenceReviewRel.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ReviewReferenceToJson(ReviewReference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'updateId': instance.updateId,
      'reviewId': instance.reviewId,
      'relevance': instance.relevance,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'reviewRel': instance.reviewRel.toJson(),
    };
