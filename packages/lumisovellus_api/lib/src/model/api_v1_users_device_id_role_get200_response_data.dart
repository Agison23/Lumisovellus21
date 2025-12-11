//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'api_v1_users_device_id_role_get200_response_data.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ApiV1UsersDeviceIdRoleGet200ResponseData {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [ApiV1UsersDeviceIdRoleGet200ResponseData] instance.
ApiV1UsersDeviceIdRoleGet200ResponseData({
  required  this.role,
  required  this.permissions,
});

  @JsonKey(
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final String role;



  @JsonKey(
    
    name: r'permissions',
    required: true,
    includeIfNull: false,
  )


  final String permissions;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ApiV1UsersDeviceIdRoleGet200ResponseData &&
      other.role == role &&
      other.permissions == permissions;

    @override
    int get hashCode =>
        role.hashCode +
        permissions.hashCode;

  factory ApiV1UsersDeviceIdRoleGet200ResponseData.fromJson(Map<String, dynamic> json) => _$ApiV1UsersDeviceIdRoleGet200ResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$ApiV1UsersDeviceIdRoleGet200ResponseDataToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

