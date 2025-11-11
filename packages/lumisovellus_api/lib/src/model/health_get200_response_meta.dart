//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'health_get200_response_meta.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HealthGet200ResponseMeta {
  /// Returns a new [HealthGet200ResponseMeta] instance.
  HealthGet200ResponseMeta({

    required  this.timestamp,

     this.message,
  });

      /// Response timestamp
  @JsonKey(
    
    name: r'timestamp',
    required: true,
    includeIfNull: false,
  )


  final DateTime timestamp;



      /// Optional success message
  @JsonKey(
    
    name: r'message',
    required: false,
    includeIfNull: false,
  )


  final String? message;





    @override
    bool operator ==(Object other) => identical(this, other) || other is HealthGet200ResponseMeta &&
      other.timestamp == timestamp &&
      other.message == message;

    @override
    int get hashCode =>
        timestamp.hashCode +
        message.hashCode;

  factory HealthGet200ResponseMeta.fromJson(Map<String, dynamic> json) => _$HealthGet200ResponseMetaFromJson(json);

  Map<String, dynamic> toJson() => _$HealthGet200ResponseMetaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

