//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'error_response_error.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ErrorResponseError {
  /// Returns a new [ErrorResponseError] instance.
  ErrorResponseError({

    required  this.code,

    required  this.message,

     this.details,
  });

      /// Error code
  @JsonKey(
    
    name: r'code',
    required: true,
    includeIfNull: false,
  )


  final String code;



      /// Error message
  @JsonKey(
    
    name: r'message',
    required: true,
    includeIfNull: false,
  )


  final String message;



      /// Additional error details
  @JsonKey(
    
    name: r'details',
    required: false,
    includeIfNull: false,
  )


  final Object? details;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ErrorResponseError &&
      other.code == code &&
      other.message == message &&
      other.details == details;

    @override
    int get hashCode =>
        code.hashCode +
        message.hashCode +
        (details == null ? 0 : details.hashCode);

  factory ErrorResponseError.fromJson(Map<String, dynamic> json) => _$ErrorResponseErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseErrorToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

