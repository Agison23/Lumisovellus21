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
  /// Returns a new [CreateSnowTypeRequest] instance.
  CreateSnowTypeRequest({

    required  this.name,

    required  this.colour,

     this.skiability,

     this.categoryId,

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



      /// Category ID
          // minimum: -9007199254740991
          // maximum: 9007199254740991
  @JsonKey(
    
    name: r'categoryId',
    required: false,
    includeIfNull: false,
  )


  final int? categoryId;



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
      other.categoryId == categoryId &&
      other.explanation == explanation;

    @override
    int get hashCode =>
        name.hashCode +
        colour.hashCode +
        (skiability == null ? 0 : skiability.hashCode) +
        (categoryId == null ? 0 : categoryId.hashCode) +
        (explanation == null ? 0 : explanation.hashCode);

  factory CreateSnowTypeRequest.fromJson(Map<String, dynamic> json) => _$CreateSnowTypeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateSnowTypeRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

