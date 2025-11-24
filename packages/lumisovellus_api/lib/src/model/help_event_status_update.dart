//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'help_event_status_update.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HelpEventStatusUpdate {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [HelpEventStatusUpdate] instance.
HelpEventStatusUpdate({
  required  this.status,
});

      /// Help event status
  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final HelpEventStatusUpdateStatusEnum status;





    @override
    bool operator ==(Object other) => identical(this, other) || other is HelpEventStatusUpdate &&
      other.status == status;

    @override
    int get hashCode =>
        status.hashCode;

  factory HelpEventStatusUpdate.fromJson(Map<String, dynamic> json) => _$HelpEventStatusUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$HelpEventStatusUpdateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

/// Help event status
enum HelpEventStatusUpdateStatusEnum {
    /// Help event status
@JsonValue(r'active')
active(r'active'),
    /// Help event status
@JsonValue(r'completed')
completed(r'completed'),
    /// Help event status
@JsonValue(r'cancelled')
cancelled(r'cancelled');

const HelpEventStatusUpdateStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


