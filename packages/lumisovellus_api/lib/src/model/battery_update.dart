//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'battery_update.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BatteryUpdate {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [BatteryUpdate] instance.
BatteryUpdate({
  required  this.batteryStatus,
});

      /// Battery status
  @JsonKey(
    
    name: r'batteryStatus',
    required: true,
    includeIfNull: false,
  )


  final BatteryUpdateBatteryStatusEnum batteryStatus;





    @override
    bool operator ==(Object other) => identical(this, other) || other is BatteryUpdate &&
      other.batteryStatus == batteryStatus;

    @override
    int get hashCode =>
        batteryStatus.hashCode;

  factory BatteryUpdate.fromJson(Map<String, dynamic> json) => _$BatteryUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$BatteryUpdateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

/// Battery status
enum BatteryUpdateBatteryStatusEnum {
    /// Battery status
@JsonValue(r'low')
low(r'low'),
    /// Battery status
@JsonValue(r'normal')
normal(r'normal');

const BatteryUpdateBatteryStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


