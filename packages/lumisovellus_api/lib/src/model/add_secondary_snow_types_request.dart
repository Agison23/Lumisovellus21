//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'add_secondary_snow_types_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AddSecondarySnowTypesRequest {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [AddSecondarySnowTypesRequest] instance.
AddSecondarySnowTypesRequest({
  this.secondarySnowTypeIds = const [],
});

      /// Array of secondary snow type IDs
  @JsonKey(
    
    name: r'secondarySnowTypeIds',
    required: true,
    includeIfNull: false,
  )


  final List<String> secondarySnowTypeIds;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AddSecondarySnowTypesRequest &&
      other.secondarySnowTypeIds == secondarySnowTypeIds;

    @override
    int get hashCode =>
        secondarySnowTypeIds.hashCode;

  factory AddSecondarySnowTypesRequest.fromJson(Map<String, dynamic> json) => _$AddSecondarySnowTypesRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddSecondarySnowTypesRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

