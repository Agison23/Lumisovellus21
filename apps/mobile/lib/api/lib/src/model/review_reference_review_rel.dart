//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:lumisovellus_api/src/model/review_reference_review_rel_user_id.dart';
import 'package:lumisovellus_api/src/model/review_reference_review_rel_hazards.dart';
import 'package:lumisovellus_api/src/model/review_reference_review_rel_secondary_snow_type.dart';
import 'package:lumisovellus_api/src/model/review_reference_review_rel_comment.dart';
import 'package:lumisovellus_api/src/model/review_reference_review_rel_snow_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review_reference_review_rel.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReviewReferenceReviewRel {
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



  @JsonKey(
    
    name: r'snowType',
    required: true,
    includeIfNull: false,
  )


  final ReviewReferenceReviewRelSnowType snowType;



  @JsonKey(
    
    name: r'secondarySnowType',
    required: true,
    includeIfNull: false,
  )


  final ReviewReferenceReviewRelSecondarySnowType secondarySnowType;



  @JsonKey(
    
    name: r'hazards',
    required: true,
    includeIfNull: false,
  )


  final ReviewReferenceReviewRelHazards hazards;



  @JsonKey(
    
    name: r'comment',
    required: true,
    includeIfNull: false,
  )


  final ReviewReferenceReviewRelComment comment;



  @JsonKey(
    
    name: r'userId',
    required: true,
    includeIfNull: false,
  )


  final ReviewReferenceReviewRelUserId userId;



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
        snowType.hashCode +
        secondarySnowType.hashCode +
        hazards.hashCode +
        comment.hashCode +
        userId.hashCode +
        createdAt.hashCode +
        updatedAt.hashCode;

  factory ReviewReferenceReviewRel.fromJson(Map<String, dynamic> json) => _$ReviewReferenceReviewRelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewReferenceReviewRelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

