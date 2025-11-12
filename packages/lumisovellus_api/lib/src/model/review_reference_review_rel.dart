//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'review_reference_review_rel.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReviewReferenceReviewRel {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [ReviewReferenceReviewRel] instance.
ReviewReferenceReviewRel({
  required  this.id,
  required  this.time,
  required  this.segment,
  required  this.snowType,
  required  this.secondarySnowType,
  required  this.hazards,
  required  this.comment,
  required  this.userId,
  required  this.createdAt,
  required  this.updatedAt,
});

      /// Review ID
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



      /// Review time
  @JsonKey(
    
    name: r'time',
    required: true,
    includeIfNull: false,
  )


  final DateTime time;



      /// Segment ID
  @JsonKey(
    
    name: r'segment',
    required: true,
    includeIfNull: false,
  )


  final String segment;



      /// Snow type ID
  @JsonKey(
    
    name: r'snowType',
    required: true,
    includeIfNull: true,
  )


  final String? snowType;



      /// Secondary snow type ID
  @JsonKey(
    
    name: r'secondarySnowType',
    required: true,
    includeIfNull: true,
  )


  final String? secondarySnowType;



      /// Hazards (JSON)
  @JsonKey(
    
    name: r'hazards',
    required: true,
    includeIfNull: true,
  )


  final Object? hazards;



      /// Review comment
  @JsonKey(
    
    name: r'comment',
    required: true,
    includeIfNull: true,
  )


  final String? comment;



      /// User ID
  @JsonKey(
    
    name: r'userId',
    required: true,
    includeIfNull: true,
  )


  final String? userId;



      /// Creation timestamp
  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



      /// Update timestamp
  @JsonKey(
    
    name: r'updatedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime updatedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ReviewReferenceReviewRel &&
      other.id == id &&
      other.time == time &&
      other.segment == segment &&
      other.snowType == snowType &&
      other.secondarySnowType == secondarySnowType &&
      other.hazards == hazards &&
      other.comment == comment &&
      other.userId == userId &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;

    @override
    int get hashCode =>
        id.hashCode +
        time.hashCode +
        segment.hashCode +
        (snowType == null ? 0 : snowType.hashCode) +
        (secondarySnowType == null ? 0 : secondarySnowType.hashCode) +
        (hazards == null ? 0 : hazards.hashCode) +
        (comment == null ? 0 : comment.hashCode) +
        (userId == null ? 0 : userId.hashCode) +
        createdAt.hashCode +
        updatedAt.hashCode;

  factory ReviewReferenceReviewRel.fromJson(Map<String, dynamic> json) => _$ReviewReferenceReviewRelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewReferenceReviewRelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

