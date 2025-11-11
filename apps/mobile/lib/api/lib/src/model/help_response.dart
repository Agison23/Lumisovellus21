//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'help_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HelpResponse {
  /// Returns a new [HelpResponse] instance.
  HelpResponse({

    required  this.helpGiver,

    required  this.helpRequester,

    required  this.state,
  });

      /// User ID of the person providing help
  @JsonKey(
    
    name: r'helpGiver',
    required: true,
    includeIfNull: false,
  )


  final String helpGiver;



      /// User ID of the person requesting help
  @JsonKey(
    
    name: r'helpRequester',
    required: true,
    includeIfNull: false,
  )


  final String helpRequester;



      /// Response state (0: Pending, 1: Accepted, 2: Declined, 3: Completed)
          // minimum: 0
          // maximum: 3
  @JsonKey(
    
    name: r'state',
    required: true,
    includeIfNull: false,
  )


  final int state;





    @override
    bool operator ==(Object other) => identical(this, other) || other is HelpResponse &&
      other.helpGiver == helpGiver &&
      other.helpRequester == helpRequester &&
      other.state == state;

    @override
    int get hashCode =>
        helpGiver.hashCode +
        helpRequester.hashCode +
        state.hashCode;

  factory HelpResponse.fromJson(Map<String, dynamic> json) => _$HelpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HelpResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

