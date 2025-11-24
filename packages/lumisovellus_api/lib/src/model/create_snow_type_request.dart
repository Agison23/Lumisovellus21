//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'create_snow_type_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateSnowTypeRequest {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [CreateSnowTypeRequest] instance.
CreateSnowTypeRequest({
  required  this.name,
  required  this.colour,
   this.skiability,
   this.primarySnowTypeId,
   this.explanation,
});

      /// Snow type name
  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



      /// Snow type colour in hex format
  @JsonKey(
    
    name: r'colour',
    required: true,
    includeIfNull: false,
  )


  final String colour;



      /// Skiability rating (1-5)
          // minimum: 1
          // maximum: 5
  @JsonKey(
    
    name: r'skiability',
    required: false,
    includeIfNull: false,
  )


  final int? skiability;



      /// Primary snow type ID. NULL for primary snow types, UUID for secondary snow types
  @JsonKey(
    
    name: r'primarySnowTypeId',
    required: false,
    includeIfNull: false,
  )


  final String? primarySnowTypeId;



      /// Explanation of the snow type
  @JsonKey(
    
    name: r'explanation',
    required: false,
    includeIfNull: false,
  )


  final String? explanation;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CreateSnowTypeRequest &&
      other.name == name &&
      other.colour == colour &&
      other.skiability == skiability &&
      other.primarySnowTypeId == primarySnowTypeId &&
      other.explanation == explanation;

    @override
    int get hashCode =>
        name.hashCode +
        colour.hashCode +
        (skiability == null ? 0 : skiability.hashCode) +
        (primarySnowTypeId == null ? 0 : primarySnowTypeId.hashCode) +
        (explanation == null ? 0 : explanation.hashCode);

  factory CreateSnowTypeRequest.fromJson(Map<String, dynamic> json) => _$CreateSnowTypeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateSnowTypeRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

