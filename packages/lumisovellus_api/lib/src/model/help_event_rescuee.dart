//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:lumisovellus_api/src/model/help_event_user_status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'help_event_rescuee.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HelpEventRescuee {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [HelpEventRescuee] instance.
HelpEventRescuee({
  required  this.userId,
  required  this.needType,
  required  this.userStatus,
});

      /// Rescuee user ID
  @JsonKey(
    
    name: r'userId',
    required: true,
    includeIfNull: false,
  )


  final String userId;



      /// Type of help requested
  @JsonKey(
    
    name: r'needType',
    required: true,
    includeIfNull: false,
  )


  final HelpEventRescueeNeedTypeEnum needType;



  @JsonKey(
    
    name: r'userStatus',
    required: true,
    includeIfNull: false,
  )


  final HelpEventUserStatus userStatus;





    @override
    bool operator ==(Object other) => identical(this, other) || other is HelpEventRescuee &&
      other.userId == userId &&
      other.needType == needType &&
      other.userStatus == userStatus;

    @override
    int get hashCode =>
        userId.hashCode +
        needType.hashCode +
        userStatus.hashCode;

  factory HelpEventRescuee.fromJson(Map<String, dynamic> json) => _$HelpEventRescueeFromJson(json);

  Map<String, dynamic> toJson() => _$HelpEventRescueeToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

/// Type of help requested
enum HelpEventRescueeNeedTypeEnum {
    /// Type of help requested
@JsonValue(r'health')
health(r'health'),
    /// Type of help requested
@JsonValue(r'equipment')
equipment(r'equipment'),
    /// Type of help requested
@JsonValue(r'lost')
lost(r'lost');

const HelpEventRescueeNeedTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


