//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'guide_update_request_output.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GuideUpdateRequestOutput {
  /// Returns a new [GuideUpdateRequestOutput] instance.
  GuideUpdateRequestOutput({

     this.description,

     this.primarySnowTypeIds = const [],

     this.secondarySnowTypeIds = const [],
  });

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
    required: true,
    includeIfNull: false,
  )


  final List<String> primarySnowTypeIds;



      /// Array of secondary snow type IDs (max 2)
  @JsonKey(
    defaultValue: [],
    name: r'secondarySnowTypeIds',
    required: true,
    includeIfNull: false,
  )


  final List<String> secondarySnowTypeIds;





    @override
    bool operator ==(Object other) => identical(this, other) || other is GuideUpdateRequestOutput &&
      other.description == description &&
      other.primarySnowTypeIds == primarySnowTypeIds &&
      other.secondarySnowTypeIds == secondarySnowTypeIds;

    @override
    int get hashCode =>
        (description == null ? 0 : description.hashCode) +
        primarySnowTypeIds.hashCode +
        secondarySnowTypeIds.hashCode;

  factory GuideUpdateRequestOutput.fromJson(Map<String, dynamic> json) => _$GuideUpdateRequestOutputFromJson(json);

  Map<String, dynamic> toJson() => _$GuideUpdateRequestOutputToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

