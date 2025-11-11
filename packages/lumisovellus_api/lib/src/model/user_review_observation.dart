//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'user_review_observation.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserReviewObservation {
  /// Returns a new [UserReviewObservation] instance.
  UserReviewObservation({

    required  this.submittedAt,

    required  this.snowTypeId,

    required  this.hazards,
  });

      /// When the review was submitted
  @JsonKey(
    
    name: r'submittedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime submittedAt;



      /// Snow type ID
  @JsonKey(
    
    name: r'snowTypeId',
    required: true,
    includeIfNull: false,
  )


  final String snowTypeId;



      /// Array of hazards
  @JsonKey(
    
    name: r'hazards',
    required: true,
    includeIfNull: false,
  )


  final List<String> hazards;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UserReviewObservation &&
      other.submittedAt == submittedAt &&
      other.snowTypeId == snowTypeId &&
      other.hazards == hazards;

    @override
    int get hashCode =>
        submittedAt.hashCode +
        snowTypeId.hashCode +
        hazards.hashCode;

  factory UserReviewObservation.fromJson(Map<String, dynamic> json) => _$UserReviewObservationFromJson(json);

  Map<String, dynamic> toJson() => _$UserReviewObservationToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

