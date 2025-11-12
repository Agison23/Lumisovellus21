//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'error_response_meta.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ErrorResponseMeta {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [ErrorResponseMeta] instance.
ErrorResponseMeta({
  required  this.timestamp,
});

      /// Response timestamp
  @JsonKey(
    
    name: r'timestamp',
    required: true,
    includeIfNull: false,
  )


  final DateTime timestamp;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ErrorResponseMeta &&
      other.timestamp == timestamp;

    @override
    int get hashCode =>
        timestamp.hashCode;

  factory ErrorResponseMeta.fromJson(Map<String, dynamic> json) => _$ErrorResponseMetaFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseMetaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

