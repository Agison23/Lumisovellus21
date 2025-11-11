//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'api_v1_segments_id_reviews_post_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ApiV1SegmentsIdReviewsPostRequest {
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


  final List<ApiV1SegmentsIdReviewsPostRequestHazardsEnum>? hazards;



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

/// Hazard type found on the trail
enum ApiV1SegmentsIdReviewsPostRequestHazardsEnum {
    /// Hazard type found on the trail
@JsonValue(r'stones')
stones(r'stones'),
    /// Hazard type found on the trail
@JsonValue(r'branches')
branches(r'branches');

const ApiV1SegmentsIdReviewsPostRequestHazardsEnum(this.value);

final String value;

@override
String toString() => value;
}


