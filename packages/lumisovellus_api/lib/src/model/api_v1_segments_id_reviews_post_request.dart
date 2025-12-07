//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:lumisovellus_api/src/model/hazard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_v1_segments_id_reviews_post_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ApiV1SegmentsIdReviewsPostRequest {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [ApiV1SegmentsIdReviewsPostRequest] instance.
ApiV1SegmentsIdReviewsPostRequest({
  required  this.snowType,
  this.hazards = const [],
   this.comment,
});

      /// Snow type ID (UUID)
  @JsonKey(
    
    name: r'snowType',
    required: true,
    includeIfNull: false,
  )


  final String snowType;



      /// Array of hazards found on the trail (e.g., [\"stones\", \"branches\"])
  @JsonKey(
    defaultValue: [],
    name: r'hazards',
    required: false,
    includeIfNull: false,
  )


  final List<Hazard>? hazards;



      /// Optional review comment
  @JsonKey(
    
    name: r'comment',
    required: false,
    includeIfNull: false,
  )


  final String? comment;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ApiV1SegmentsIdReviewsPostRequest &&
      other.snowType == snowType &&
      other.hazards == hazards &&
      other.comment == comment;

    @override
    int get hashCode =>
        snowType.hashCode +
        hazards.hashCode +
        (comment == null ? 0 : comment.hashCode);

  factory ApiV1SegmentsIdReviewsPostRequest.fromJson(Map<String, dynamic> json) => _$ApiV1SegmentsIdReviewsPostRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ApiV1SegmentsIdReviewsPostRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

