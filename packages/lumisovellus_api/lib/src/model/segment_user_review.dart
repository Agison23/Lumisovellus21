//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'segment_user_review.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SegmentUserReview {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [SegmentUserReview] instance.
SegmentUserReview({
  required  this.submittedAt,
  required  this.snowTypeId,
  required  this.secondarySnowTypeId,
  this.hazards = const [],
});

  @JsonKey(
    
    name: r'submittedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime submittedAt;



  @JsonKey(
    
    name: r'snowTypeId',
    required: true,
    includeIfNull: false,
  )


  final String snowTypeId;



  @JsonKey(
    
    name: r'secondarySnowTypeId',
    required: true,
    includeIfNull: true,
  )


  final String? secondarySnowTypeId;



  @JsonKey(
    
    name: r'hazards',
    required: true,
    includeIfNull: false,
  )


  final List<String> hazards;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SegmentUserReview &&
      other.submittedAt == submittedAt &&
      other.snowTypeId == snowTypeId &&
      other.secondarySnowTypeId == secondarySnowTypeId &&
      other.hazards == hazards;

    @override
    int get hashCode =>
        submittedAt.hashCode +
        snowTypeId.hashCode +
        (secondarySnowTypeId == null ? 0 : secondarySnowTypeId.hashCode) +
        hazards.hashCode;

  factory SegmentUserReview.fromJson(Map<String, dynamic> json) => _$SegmentUserReviewFromJson(json);

  Map<String, dynamic> toJson() => _$SegmentUserReviewToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

