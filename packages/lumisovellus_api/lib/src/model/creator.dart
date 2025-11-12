//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'creator.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Creator {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [Creator] instance.
Creator({
  required  this.firstName,
  required  this.lastName,
});

      /// Creator first name
  @JsonKey(
    
    name: r'firstName',
    required: true,
    includeIfNull: true,
  )


  final String? firstName;



      /// Creator last name
  @JsonKey(
    
    name: r'lastName',
    required: true,
    includeIfNull: true,
  )


  final String? lastName;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Creator &&
      other.firstName == firstName &&
      other.lastName == lastName;

    @override
    int get hashCode =>
        (firstName == null ? 0 : firstName.hashCode) +
        (lastName == null ? 0 : lastName.hashCode);

  factory Creator.fromJson(Map<String, dynamic> json) => _$CreatorFromJson(json);

  Map<String, dynamic> toJson() => _$CreatorToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

