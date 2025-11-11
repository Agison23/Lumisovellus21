//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:lumisovellus_api/src/model/auth_response.dart';
import 'package:lumisovellus_api/src/model/health_get200_response_meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_register_post201_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AuthRegisterPost201Response {
  /// Returns a new [AuthRegisterPost201Response] instance.
  AuthRegisterPost201Response({

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


  final AuthResponse data;



  @JsonKey(
    
    name: r'meta',
    required: true,
    includeIfNull: false,
  )


  final HealthGet200ResponseMeta meta;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AuthRegisterPost201Response &&
      other.success == success &&
      other.data == data &&
      other.meta == meta;

    @override
    int get hashCode =>
        success.hashCode +
        data.hashCode +
        meta.hashCode;

  factory AuthRegisterPost201Response.fromJson(Map<String, dynamic> json) => _$AuthRegisterPost201ResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthRegisterPost201ResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

