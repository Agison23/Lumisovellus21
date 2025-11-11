//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'auth_reset_password_post200_response_meta.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AuthResetPasswordPost200ResponseMeta {
  /// Returns a new [AuthResetPasswordPost200ResponseMeta] instance.
  AuthResetPasswordPost200ResponseMeta({

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
    bool operator ==(Object other) => identical(this, other) || other is AuthResetPasswordPost200ResponseMeta &&
      other.timestamp == timestamp &&
      other.message == message;

    @override
    int get hashCode =>
        timestamp.hashCode +
        message.hashCode;

  factory AuthResetPasswordPost200ResponseMeta.fromJson(Map<String, dynamic> json) => _$AuthResetPasswordPost200ResponseMetaFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResetPasswordPost200ResponseMetaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

