//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:lumisovellus_api/src/model/hazard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'guide_update_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GuideUpdateRequest {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [GuideUpdateRequest] instance.
GuideUpdateRequest({
   this.description,
  this.primarySnowTypeIds = const [],
  this.secondarySnowTypeIds = const [],
  this.hazards = const [],
});

      /// Description of the guide update
  @JsonKey(
    
    name: r'description',
    required: false,
    includeIfNull: false,
  )


  final String? description;



      /// Array of primary snow type IDs (max 2)
  @JsonKey(
    defaultValue: [],
    name: r'primarySnowTypeIds',
    required: false,
    includeIfNull: false,
  )


  final List<String>? primarySnowTypeIds;



      /// Array of secondary snow type IDs (max 2)
  @JsonKey(
    defaultValue: [],
    name: r'secondarySnowTypeIds',
    required: false,
    includeIfNull: false,
  )


  final List<String>? secondarySnowTypeIds;



      /// Array of hazards found on the trail (e.g., [\"stones\", \"branches\"])
  @JsonKey(
    defaultValue: [],
    name: r'hazards',
    required: false,
    includeIfNull: false,
  )


  final List<Hazard>? hazards;





    @override
    bool operator ==(Object other) => identical(this, other) || other is GuideUpdateRequest &&
      other.description == description &&
      other.primarySnowTypeIds == primarySnowTypeIds &&
      other.secondarySnowTypeIds == secondarySnowTypeIds &&
      other.hazards == hazards;

    @override
    int get hashCode =>
        (description == null ? 0 : description.hashCode) +
        primarySnowTypeIds.hashCode +
        secondarySnowTypeIds.hashCode +
        hazards.hashCode;

  factory GuideUpdateRequest.fromJson(Map<String, dynamic> json) => _$GuideUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GuideUpdateRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

