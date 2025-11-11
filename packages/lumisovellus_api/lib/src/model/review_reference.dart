//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:lumisovellus_api/src/model/review_reference_review_rel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review_reference.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReviewReference {
  /// Returns a new [ReviewReference] instance.
  ReviewReference({

    required  this.id,

    required  this.updateId,

    required  this.reviewId,

    required  this.relevance,

    required  this.notes,

    required  this.createdAt,

    required  this.reviewRel,
  });

      /// Review reference ID
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



      /// Snow update ID
  @JsonKey(
    
    name: r'updateId',
    required: true,
    includeIfNull: false,
  )


  final String updateId;



      /// User review ID
  @JsonKey(
    
    name: r'reviewId',
    required: true,
    includeIfNull: false,
  )


  final String reviewId;



      /// Relevance score
          // minimum: -9007199254740991
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'relevance',
    required: true,
    includeIfNull: false,
  )


  final int relevance;



      /// Reference notes
  @JsonKey(
    
    name: r'notes',
    required: true,
    includeIfNull: true,
  )


  final String? notes;



      /// Creation timestamp
  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'reviewRel',
    required: true,
    includeIfNull: false,
  )


  final ReviewReferenceReviewRel reviewRel;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ReviewReference &&
      other.id == id &&
      other.updateId == updateId &&
      other.reviewId == reviewId &&
      other.relevance == relevance &&
      other.notes == notes &&
      other.createdAt == createdAt &&
      other.reviewRel == reviewRel;

    @override
    int get hashCode =>
        id.hashCode +
        updateId.hashCode +
        reviewId.hashCode +
        relevance.hashCode +
        (notes == null ? 0 : notes.hashCode) +
        createdAt.hashCode +
        reviewRel.hashCode;

  factory ReviewReference.fromJson(Map<String, dynamic> json) => _$ReviewReferenceFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewReferenceToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

