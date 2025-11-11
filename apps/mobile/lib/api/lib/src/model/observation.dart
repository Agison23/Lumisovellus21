//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:lumisovellus_api/src/model/guide_update_request_output.dart';
import 'package:lumisovellus_api/src/model/user_review_observation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'observation.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Observation {
  /// Returns a new [Observation] instance.
  Observation({

    required  this.segmentId,

    required  this.guideUpdate,

    required  this.userReviews,
  });

      /// Segment ID
  @JsonKey(
    
    name: r'segmentId',
    required: true,
    includeIfNull: false,
  )


  final String segmentId;



  @JsonKey(
    
    name: r'guideUpdate',
    required: true,
    includeIfNull: true,
  )


  final GuideUpdateRequestOutput? guideUpdate;



      /// User reviews for the segment
  @JsonKey(
    
    name: r'userReviews',
    required: true,
    includeIfNull: false,
  )


  final List<UserReviewObservation> userReviews;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Observation &&
      other.segmentId == segmentId &&
      other.guideUpdate == guideUpdate &&
      other.userReviews == userReviews;

    @override
    int get hashCode =>
        segmentId.hashCode +
        (guideUpdate == null ? 0 : guideUpdate.hashCode) +
        userReviews.hashCode;

  factory Observation.fromJson(Map<String, dynamic> json) => _$ObservationFromJson(json);

  Map<String, dynamic> toJson() => _$ObservationToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

