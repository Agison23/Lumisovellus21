//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'segment_point.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SegmentPoint {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [SegmentPoint] instance.
SegmentPoint({
  required  this.lat,
  required  this.lng,
});

      /// Latitude
  @JsonKey(
    
    name: r'lat',
    required: true,
    includeIfNull: false,
  )


  final num lat;



      /// Longitude
  @JsonKey(
    
    name: r'lng',
    required: true,
    includeIfNull: false,
  )


  final num lng;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SegmentPoint &&
      other.lat == lat &&
      other.lng == lng;

    @override
    int get hashCode =>
        lat.hashCode +
        lng.hashCode;

  factory SegmentPoint.fromJson(Map<String, dynamic> json) => _$SegmentPointFromJson(json);

  Map<String, dynamic> toJson() => _$SegmentPointToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

