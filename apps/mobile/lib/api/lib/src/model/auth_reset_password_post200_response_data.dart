//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'auth_reset_password_post200_response_data.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AuthResetPasswordPost200ResponseData {
  /// Returns a new [AuthResetPasswordPost200ResponseData] instance.
  AuthResetPasswordPost200ResponseData({

    required  this.message,
  });

  @JsonKey(
    
    name: r'message',
    required: true,
    includeIfNull: false,
  )


  final String message;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AuthResetPasswordPost200ResponseData &&
      other.message == message;

    @override
    int get hashCode =>
        message.hashCode;

  factory AuthResetPasswordPost200ResponseData.fromJson(Map<String, dynamic> json) => _$AuthResetPasswordPost200ResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResetPasswordPost200ResponseDataToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

