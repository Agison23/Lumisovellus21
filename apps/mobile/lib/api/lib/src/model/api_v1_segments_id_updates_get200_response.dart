//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:lumisovellus_api/src/model/segment_update.dart';
import 'package:lumisovellus_api/src/model/auth_reset_password_post200_response_meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_v1_segments_id_updates_get200_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ApiV1SegmentsIdUpdatesGet200Response {
  /// Returns a new [ApiV1SegmentsIdUpdatesGet200Response] instance.
  ApiV1SegmentsIdUpdatesGet200Response({

    required  this.success,

    required  this.data,

    required  this.meta,
  });

      /// Indicates if the request was successful
  @JsonKey(
    
    name: r'success',
    required: true,
    includeIfNull: false,
  )


  final bool success;



  @JsonKey(
    
    name: r'data',
    required: true,
    includeIfNull: false,
  )


  final List<SegmentUpdate> data;



  @JsonKey(
    
    name: r'meta',
    required: true,
    includeIfNull: false,
  )


  final AuthResetPasswordPost200ResponseMeta meta;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ApiV1SegmentsIdUpdatesGet200Response &&
      other.success == success &&
      other.data == data &&
      other.meta == meta;

    @override
    int get hashCode =>
        success.hashCode +
        data.hashCode +
        meta.hashCode;

  factory ApiV1SegmentsIdUpdatesGet200Response.fromJson(Map<String, dynamic> json) => _$ApiV1SegmentsIdUpdatesGet200ResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiV1SegmentsIdUpdatesGet200ResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

