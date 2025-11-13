//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:lumisovellus_api/src/model/segment_user_review.dart';
import 'package:lumisovellus_api/src/model/guide_update_request_output.dart';
import 'package:lumisovellus_api/src/model/segment_point.dart';
import 'package:json_annotation/json_annotation.dart';

part 'segment.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Segment {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [Segment] instance.
Segment({
  required  this.id,
  required  this.name,
  required  this.terrain,
  required  this.avalancheDanger,
  required  this.isLowerSegment,
  this.points = const [],
  required  this.guideUpdate,
  this.userReviews = const [],
});

      /// Segment ID
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



      /// Segment name
  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



      /// Terrain description
  @JsonKey(
    
    name: r'terrain',
    required: true,
    includeIfNull: false,
  )


  final String terrain;



  @JsonKey(
    
    name: r'avalancheDanger',
    required: true,
    includeIfNull: false,
  )


  final bool avalancheDanger;



          // minimum: -9007199254740991
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'isLowerSegment',
    required: true,
    includeIfNull: true,
  )


  final int? isLowerSegment;



      /// Polygon or polyline of the segment
  @JsonKey(
    
    name: r'points',
    required: true,
    includeIfNull: false,
  )


  final List<SegmentPoint> points;



  @JsonKey(
    
    name: r'guideUpdate',
    required: true,
    includeIfNull: true,
  )


  final GuideUpdateRequestOutput? guideUpdate;



  @JsonKey(
    
    name: r'userReviews',
    required: true,
    includeIfNull: false,
  )


  final List<SegmentUserReview> userReviews;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Segment &&
      other.id == id &&
      other.name == name &&
      other.terrain == terrain &&
      other.avalancheDanger == avalancheDanger &&
      other.isLowerSegment == isLowerSegment &&
      other.points == points &&
      other.guideUpdate == guideUpdate &&
      other.userReviews == userReviews;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        terrain.hashCode +
        avalancheDanger.hashCode +
        (isLowerSegment == null ? 0 : isLowerSegment.hashCode) +
        points.hashCode +
        (guideUpdate == null ? 0 : guideUpdate.hashCode) +
        userReviews.hashCode;

  factory Segment.fromJson(Map<String, dynamic> json) => _$SegmentFromJson(json);

  Map<String, dynamic> toJson() => _$SegmentToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

