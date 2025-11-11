//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'role_update.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RoleUpdate {
  /// Returns a new [RoleUpdate] instance.
  RoleUpdate({

    required  this.role,
  });

      /// User role
  @JsonKey(
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final String role;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RoleUpdate &&
      other.role == role;

    @override
    int get hashCode =>
        role.hashCode;

  factory RoleUpdate.fromJson(Map<String, dynamic> json) => _$RoleUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$RoleUpdateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

