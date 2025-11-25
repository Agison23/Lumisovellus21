//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'snow_type.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SnowType {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [SnowType] instance.
SnowType({
  required  this.id,
  required  this.identifier,
  required  this.name,
  required  this.colour,
  required  this.skiability,
  required  this.primarySnowTypeId,
  required  this.explanation,
});

      /// Snow type ID
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



      /// Snow type identifier (slug)
  @JsonKey(
    
    name: r'identifier',
    required: true,
    includeIfNull: false,
  )


  final String identifier;



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
          // minimum: -9007199254740991
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'skiability',
    required: true,
    includeIfNull: true,
  )


  final int? skiability;



      /// Primary snow type ID. NULL for primary snow types, UUID for secondary snow types
  @JsonKey(
    
    name: r'primarySnowTypeId',
    required: true,
    includeIfNull: true,
  )


  final String? primarySnowTypeId;



      /// Explanation of the snow type
  @JsonKey(
    
    name: r'explanation',
    required: true,
    includeIfNull: true,
  )


  final String? explanation;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SnowType &&
      other.id == id &&
      other.identifier == identifier &&
      other.name == name &&
      other.colour == colour &&
      other.skiability == skiability &&
      other.primarySnowTypeId == primarySnowTypeId &&
      other.explanation == explanation;

    @override
    int get hashCode =>
        id.hashCode +
        identifier.hashCode +
        name.hashCode +
        colour.hashCode +
        (skiability == null ? 0 : skiability.hashCode) +
        (primarySnowTypeId == null ? 0 : primarySnowTypeId.hashCode) +
        (explanation == null ? 0 : explanation.hashCode);

  factory SnowType.fromJson(Map<String, dynamic> json) => _$SnowTypeFromJson(json);

  Map<String, dynamic> toJson() => _$SnowTypeToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

