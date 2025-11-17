//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:lumisovellus_api/src/model/help_event_rescuee_view.dart';
import 'package:lumisovellus_api/src/model/health_get200_response_meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'help_events_post201_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HelpEventsPost201Response {
/// Modified to fix Dart constructor errors (dart_constructor.mustache):
/// Adds `const []` as default for list fields to avoid non-nullable parameter issues,
/// while keeping normal defaults for all other field types.
/// Returns a new [HelpEventsPost201Response] instance.
HelpEventsPost201Response({
  required  this.success,
  required  this.data,
  required  this.meta,
});

      /// Indicates if the request was successful
  @JsonKey(
    
    name: r'success',
    required: true,
    includeIfNull: false,
  )


  final bool success;



  @JsonKey(
    
    name: r'data',
    required: true,
    includeIfNull: false,
  )


  final HelpEventRescueeView data;



  @JsonKey(
    
    name: r'meta',
    required: true,
    includeIfNull: false,
  )


  final HealthGet200ResponseMeta meta;





    @override
    bool operator ==(Object other) => identical(this, other) || other is HelpEventsPost201Response &&
      other.success == success &&
      other.data == data &&
      other.meta == meta;

    @override
    int get hashCode =>
        success.hashCode +
        data.hashCode +
        meta.hashCode;

  factory HelpEventsPost201Response.fromJson(Map<String, dynamic> json) => _$HelpEventsPost201ResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HelpEventsPost201ResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

