//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:lumisovellus_api/src/model/auth_verify_token_get200_response_data_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_verify_token_get200_response_data.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AuthVerifyTokenGet200ResponseData {
  /// Returns a new [AuthVerifyTokenGet200ResponseData] instance.
  AuthVerifyTokenGet200ResponseData({

    required  this.valid,

    required  this.user,
  });

  @JsonKey(
    
    name: r'valid',
    required: true,
    includeIfNull: false,
  )


  final bool valid;



  @JsonKey(
    
    name: r'user',
    required: true,
    includeIfNull: false,
  )


  final AuthVerifyTokenGet200ResponseDataUser user;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AuthVerifyTokenGet200ResponseData &&
      other.valid == valid &&
      other.user == user;

    @override
    int get hashCode =>
        valid.hashCode +
        user.hashCode;

  factory AuthVerifyTokenGet200ResponseData.fromJson(Map<String, dynamic> json) => _$AuthVerifyTokenGet200ResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$AuthVerifyTokenGet200ResponseDataToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

