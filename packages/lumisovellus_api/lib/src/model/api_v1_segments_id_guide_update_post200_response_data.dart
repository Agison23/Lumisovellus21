//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'api_v1_segments_id_guide_update_post200_response_data.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ApiV1SegmentsIdGuideUpdatePost200ResponseData {
  /// Returns a new [ApiV1SegmentsIdGuideUpdatePost200ResponseData] instance.
  ApiV1SegmentsIdGuideUpdatePost200ResponseData({

    required  this.description,

    required  this.primarySnowTypeIds,

    required  this.secondarySnowTypeIds,
  });

  @JsonKey(
    
    name: r'description',
    required: true,
    includeIfNull: true,
  )


  final String? description;



  @JsonKey(
    
    name: r'primarySnowTypeIds',
    required: true,
    includeIfNull: false,
  )


  final List<String> primarySnowTypeIds;



  @JsonKey(
    
    name: r'secondarySnowTypeIds',
    required: true,
    includeIfNull: false,
  )


  final List<String> secondarySnowTypeIds;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ApiV1SegmentsIdGuideUpdatePost200ResponseData &&
      other.description == description &&
      other.primarySnowTypeIds == primarySnowTypeIds &&
      other.secondarySnowTypeIds == secondarySnowTypeIds;

    @override
    int get hashCode =>
        (description == null ? 0 : description.hashCode) +
        primarySnowTypeIds.hashCode +
        secondarySnowTypeIds.hashCode;

  factory ApiV1SegmentsIdGuideUpdatePost200ResponseData.fromJson(Map<String, dynamic> json) => _$ApiV1SegmentsIdGuideUpdatePost200ResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$ApiV1SegmentsIdGuideUpdatePost200ResponseDataToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

