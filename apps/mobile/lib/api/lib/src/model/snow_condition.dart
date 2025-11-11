//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'snow_condition.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SnowCondition {
  /// Returns a new [SnowCondition] instance.
  SnowCondition({

    required  this.id,

    required  this.snowType,

    required  this.secondarySnowType,

    required  this.layer,

    required  this.depth,

    required  this.coverage,

    required  this.quality,

    required  this.hardness,

    required  this.moisture,

    required  this.notes,

    required  this.createdAt,
  });

      /// Snow condition ID
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'snowType',
    required: true,
    includeIfNull: true,
  )


  final String? snowType;



  @JsonKey(
    
    name: r'secondarySnowType',
    required: true,
    includeIfNull: true,
  )


  final String? secondarySnowType;



      /// Snow layer
  @JsonKey(
    
    name: r'layer',
    required: true,
    includeIfNull: false,
  )


  final SnowConditionLayerEnum layer;



  @JsonKey(
    
    name: r'depth',
    required: true,
    includeIfNull: true,
  )


  final num? depth;



  @JsonKey(
    
    name: r'coverage',
    required: true,
    includeIfNull: true,
  )


  final num? coverage;



  @JsonKey(
    
    name: r'quality',
    required: true,
    includeIfNull: true,
  )


  final num? quality;



  @JsonKey(
    
    name: r'hardness',
    required: true,
    includeIfNull: true,
  )


  final num? hardness;



  @JsonKey(
    
    name: r'moisture',
    required: true,
    includeIfNull: true,
  )


  final num? moisture;



  @JsonKey(
    
    name: r'notes',
    required: true,
    includeIfNull: true,
  )


  final String? notes;



      /// Creation timestamp
  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SnowCondition &&
      other.id == id &&
      other.snowType == snowType &&
      other.secondarySnowType == secondarySnowType &&
      other.layer == layer &&
      other.depth == depth &&
      other.coverage == coverage &&
      other.quality == quality &&
      other.hardness == hardness &&
      other.moisture == moisture &&
      other.notes == notes &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        (snowType == null ? 0 : snowType.hashCode) +
        (secondarySnowType == null ? 0 : secondarySnowType.hashCode) +
        layer.hashCode +
        (depth == null ? 0 : depth.hashCode) +
        (coverage == null ? 0 : coverage.hashCode) +
        (quality == null ? 0 : quality.hashCode) +
        (hardness == null ? 0 : hardness.hashCode) +
        (moisture == null ? 0 : moisture.hashCode) +
        (notes == null ? 0 : notes.hashCode) +
        createdAt.hashCode;

  factory SnowCondition.fromJson(Map<String, dynamic> json) => _$SnowConditionFromJson(json);

  Map<String, dynamic> toJson() => _$SnowConditionToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

/// Snow layer
enum SnowConditionLayerEnum {
    /// Snow layer
@JsonValue(r'SURFACE')
SURFACE(r'SURFACE'),
    /// Snow layer
@JsonValue(r'MIDDLE')
MIDDLE(r'MIDDLE'),
    /// Snow layer
@JsonValue(r'BASE')
BASE(r'BASE');

const SnowConditionLayerEnum(this.value);

final String value;

@override
String toString() => value;
}


