//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:lumisovellus_api/src/model/error_response_meta.dart';
import 'package:lumisovellus_api/src/model/error_response_error.dart';
import 'package:json_annotation/json_annotation.dart';

part 'error_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ErrorResponse {
  /// Returns a new [ErrorResponse] instance.
  ErrorResponse({

    required  this.success,

    required  this.error,

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
    
    name: r'error',
    required: true,
    includeIfNull: false,
  )


  final ErrorResponseError error;



  @JsonKey(
    
    name: r'meta',
    required: true,
    includeIfNull: false,
  )


  final ErrorResponseMeta meta;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ErrorResponse &&
      other.success == success &&
      other.error == error &&
      other.meta == meta;

    @override
    int get hashCode =>
        success.hashCode +
        error.hashCode +
        meta.hashCode;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => _$ErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

