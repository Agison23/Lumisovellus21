//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

/// Hazard type found on the trail
enum Hazard {
          /// Hazard type found on the trail
      @JsonValue(r'stones')
      stones(r'stones'),
          /// Hazard type found on the trail
      @JsonValue(r'branches')
      branches(r'branches');

  const Hazard(this.value);

  final String value;

  @override
  String toString() => value;
}
