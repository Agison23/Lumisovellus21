//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'review_reference_notes.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReviewReferenceNotes {
  /// Returns a new [ReviewReferenceNotes] instance.
  ReviewReferenceNotes({
  });



    @override
    bool operator ==(Object other) => identical(this, other) || other is ReviewReferenceNotes &&

    @override
    int get hashCode =>

  factory ReviewReferenceNotes.fromJson(Map<String, dynamic> json) => _$ReviewReferenceNotesFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewReferenceNotesToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

