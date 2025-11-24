//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:lumisovellus_api/src/model/help_event_location.dart';
import 'package:json_annotation/json_annotation.dart';

part 'help_event_acceptance.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HelpEventAcceptance {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [HelpEventAcceptance] instance.
HelpEventAcceptance({
  required  this.location,
});

  @JsonKey(
    
    name: r'location',
    required: true,
    includeIfNull: false,
  )


  final HelpEventLocation location;





    @override
    bool operator ==(Object other) => identical(this, other) || other is HelpEventAcceptance &&
      other.location == location;

    @override
    int get hashCode =>
        location.hashCode;

  factory HelpEventAcceptance.fromJson(Map<String, dynamic> json) => _$HelpEventAcceptanceFromJson(json);

  Map<String, dynamic> toJson() => _$HelpEventAcceptanceToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

