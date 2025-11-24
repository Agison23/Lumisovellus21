//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'review_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReviewResponse {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [ReviewResponse] instance.
ReviewResponse({
  required  this.id,
  required  this.time,
  required  this.segment,
   this.snowType,
   this.secondarySnowType,
  this.hazards = const [],
   this.comment,
   this.userId,
});

      /// Review ID
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



      /// Review submission timestamp
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
    required: false,
    includeIfNull: false,
  )


  final String? snowType;



      /// Secondary snow type ID
  @JsonKey(
    
    name: r'secondarySnowType',
    required: false,
    includeIfNull: false,
  )


  final String? secondarySnowType;



      /// Array of hazards
  @JsonKey(
    
    name: r'hazards',
    required: true,
    includeIfNull: false,
  )


  final List<String> hazards;



      /// Optional review comment
  @JsonKey(
    
    name: r'comment',
    required: false,
    includeIfNull: false,
  )


  final String? comment;



      /// User ID who created the review
  @JsonKey(
    
    name: r'userId',
    required: false,
    includeIfNull: false,
  )


  final String? userId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ReviewResponse &&
      other.id == id &&
      other.time == time &&
      other.segment == segment &&
      other.snowType == snowType &&
      other.secondarySnowType == secondarySnowType &&
      other.hazards == hazards &&
      other.comment == comment &&
      other.userId == userId;

    @override
    int get hashCode =>
        id.hashCode +
        time.hashCode +
        segment.hashCode +
        (snowType == null ? 0 : snowType.hashCode) +
        (secondarySnowType == null ? 0 : secondarySnowType.hashCode) +
        hazards.hashCode +
        (comment == null ? 0 : comment.hashCode) +
        (userId == null ? 0 : userId.hashCode);

  factory ReviewResponse.fromJson(Map<String, dynamic> json) => _$ReviewResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

