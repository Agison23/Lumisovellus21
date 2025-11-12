//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:lumisovellus_api/src/model/snow_condition.dart';
import 'package:lumisovellus_api/src/model/creator.dart';
import 'package:lumisovellus_api/src/model/review_reference.dart';
import 'package:json_annotation/json_annotation.dart';

part 'segment_update.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SegmentUpdate {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [SegmentUpdate] instance.
SegmentUpdate({
  required  this.id,
  required  this.segment,
  required  this.time,
  required  this.description,
  required  this.weather,
  required  this.temperature,
  required  this.windSpeed,
  required  this.visibility,
  required  this.status,
  required  this.priority,
  required  this.creator,
  required  this.segmentName,
  this.snowConditions = const [],
  this.reviewReferences = const [],
});

      /// Update ID
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



      /// Segment ID
  @JsonKey(
    
    name: r'segment',
    required: true,
    includeIfNull: false,
  )


  final String segment;



      /// Update timestamp
  @JsonKey(
    
    name: r'time',
    required: true,
    includeIfNull: false,
  )


  final DateTime time;



      /// Update description
  @JsonKey(
    
    name: r'description',
    required: true,
    includeIfNull: true,
  )


  final String? description;



      /// Weather conditions
  @JsonKey(
    
    name: r'weather',
    required: true,
    includeIfNull: true,
  )


  final String? weather;



      /// Temperature in Celsius
  @JsonKey(
    
    name: r'temperature',
    required: true,
    includeIfNull: true,
  )


  final num? temperature;



      /// Wind speed
  @JsonKey(
    
    name: r'windSpeed',
    required: true,
    includeIfNull: true,
  )


  final num? windSpeed;



      /// Visibility rating
  @JsonKey(
    
    name: r'visibility',
    required: true,
    includeIfNull: true,
  )


  final num? visibility;



      /// Update status
  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final SegmentUpdateStatusEnum status;



      /// Update priority
          // minimum: -9007199254740991
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'priority',
    required: true,
    includeIfNull: false,
  )


  final int priority;



      /// Update creator information
  @JsonKey(
    
    name: r'creator',
    required: true,
    includeIfNull: true,
  )


  final Creator? creator;



      /// Segment name
  @JsonKey(
    
    name: r'segmentName',
    required: true,
    includeIfNull: false,
  )


  final String segmentName;



      /// Snow conditions for this update
  @JsonKey(
    
    name: r'snowConditions',
    required: true,
    includeIfNull: false,
  )


  final List<SnowCondition> snowConditions;



      /// Review references associated with this update
  @JsonKey(
    
    name: r'reviewReferences',
    required: true,
    includeIfNull: false,
  )


  final List<ReviewReference> reviewReferences;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SegmentUpdate &&
      other.id == id &&
      other.segment == segment &&
      other.time == time &&
      other.description == description &&
      other.weather == weather &&
      other.temperature == temperature &&
      other.windSpeed == windSpeed &&
      other.visibility == visibility &&
      other.status == status &&
      other.priority == priority &&
      other.creator == creator &&
      other.segmentName == segmentName &&
      other.snowConditions == snowConditions &&
      other.reviewReferences == reviewReferences;

    @override
    int get hashCode =>
        id.hashCode +
        segment.hashCode +
        time.hashCode +
        (description == null ? 0 : description.hashCode) +
        (weather == null ? 0 : weather.hashCode) +
        (temperature == null ? 0 : temperature.hashCode) +
        (windSpeed == null ? 0 : windSpeed.hashCode) +
        (visibility == null ? 0 : visibility.hashCode) +
        status.hashCode +
        priority.hashCode +
        (creator == null ? 0 : creator.hashCode) +
        segmentName.hashCode +
        snowConditions.hashCode +
        reviewReferences.hashCode;

  factory SegmentUpdate.fromJson(Map<String, dynamic> json) => _$SegmentUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$SegmentUpdateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

/// Update status
enum SegmentUpdateStatusEnum {
    /// Update status
@JsonValue(r'DRAFT')
DRAFT(r'DRAFT'),
    /// Update status
@JsonValue(r'ACTIVE')
ACTIVE(r'ACTIVE'),
    /// Update status
@JsonValue(r'ARCHIVED')
ARCHIVED(r'ARCHIVED'),
    /// Update status
@JsonValue(r'DELETED')
DELETED(r'DELETED');

const SegmentUpdateStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


