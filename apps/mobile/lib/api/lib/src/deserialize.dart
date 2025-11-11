import 'package:lumisovellus_api/src/model/add_secondary_snow_types_request.dart';
import 'package:lumisovellus_api/src/model/api_v1_help_requests_id_helpers_get200_response.dart';
import 'package:lumisovellus_api/src/model/api_v1_help_requests_id_helpers_get200_response_data_inner.dart';
import 'package:lumisovellus_api/src/model/api_v1_help_requests_post200_response.dart';
import 'package:lumisovellus_api/src/model/api_v1_help_requests_post200_response_data.dart';
import 'package:lumisovellus_api/src/model/api_v1_observations_get200_response.dart';
import 'package:lumisovellus_api/src/model/api_v1_segments_get200_response.dart';
import 'package:lumisovellus_api/src/model/api_v1_segments_id_guide_update_post200_response.dart';
import 'package:lumisovellus_api/src/model/api_v1_segments_id_guide_update_post200_response_data.dart';
import 'package:lumisovellus_api/src/model/api_v1_segments_id_reviews_post_request.dart';
import 'package:lumisovellus_api/src/model/api_v1_segments_id_updates_get200_response.dart';
import 'package:lumisovellus_api/src/model/api_v1_snow_types_get200_response.dart';
import 'package:lumisovellus_api/src/model/api_v1_snow_types_post201_response.dart';
import 'package:lumisovellus_api/src/model/api_v1_users_device_id_location_post200_response.dart';
import 'package:lumisovellus_api/src/model/api_v1_users_device_id_location_post200_response_data.dart';
import 'package:lumisovellus_api/src/model/api_v1_users_device_id_role_get200_response.dart';
import 'package:lumisovellus_api/src/model/api_v1_users_device_id_role_get200_response_data.dart';
import 'package:lumisovellus_api/src/model/api_v1_users_get200_response.dart';
import 'package:lumisovellus_api/src/model/api_v1_users_id_put_request.dart';
import 'package:lumisovellus_api/src/model/auth_profile_get200_response.dart';
import 'package:lumisovellus_api/src/model/auth_register_post201_response.dart';
import 'package:lumisovellus_api/src/model/auth_reset_password_post200_response.dart';
import 'package:lumisovellus_api/src/model/auth_reset_password_post200_response_data.dart';
import 'package:lumisovellus_api/src/model/auth_reset_password_post200_response_meta.dart';
import 'package:lumisovellus_api/src/model/auth_response.dart';
import 'package:lumisovellus_api/src/model/auth_response_user.dart';
import 'package:lumisovellus_api/src/model/auth_verify_token_get200_response.dart';
import 'package:lumisovellus_api/src/model/auth_verify_token_get200_response_data.dart';
import 'package:lumisovellus_api/src/model/auth_verify_token_get200_response_data_user.dart';
import 'package:lumisovellus_api/src/model/auth_verify_token_get200_response_data_user_last_name.dart';
import 'package:lumisovellus_api/src/model/battery_update.dart';
import 'package:lumisovellus_api/src/model/change_password_request.dart';
import 'package:lumisovellus_api/src/model/create_snow_type_request.dart';
import 'package:lumisovellus_api/src/model/creator.dart';
import 'package:lumisovellus_api/src/model/error_response.dart';
import 'package:lumisovellus_api/src/model/error_response_error.dart';
import 'package:lumisovellus_api/src/model/error_response_meta.dart';
import 'package:lumisovellus_api/src/model/guide_update_request.dart';
import 'package:lumisovellus_api/src/model/guide_update_request_output.dart';
import 'package:lumisovellus_api/src/model/health_get200_response.dart';
import 'package:lumisovellus_api/src/model/health_get200_response_meta.dart';
import 'package:lumisovellus_api/src/model/health_response.dart';
import 'package:lumisovellus_api/src/model/help_request.dart';
import 'package:lumisovellus_api/src/model/help_response.dart';
import 'package:lumisovellus_api/src/model/location_update.dart';
import 'package:lumisovellus_api/src/model/login_request.dart';
import 'package:lumisovellus_api/src/model/observation.dart';
import 'package:lumisovellus_api/src/model/refresh_token_request.dart';
import 'package:lumisovellus_api/src/model/register_request.dart';
import 'package:lumisovellus_api/src/model/reset_password_request.dart';
import 'package:lumisovellus_api/src/model/review_reference.dart';
import 'package:lumisovellus_api/src/model/review_reference_notes.dart';
import 'package:lumisovellus_api/src/model/review_reference_review_rel.dart';
import 'package:lumisovellus_api/src/model/review_reference_review_rel_comment.dart';
import 'package:lumisovellus_api/src/model/review_reference_review_rel_hazards.dart';
import 'package:lumisovellus_api/src/model/review_reference_review_rel_secondary_snow_type.dart';
import 'package:lumisovellus_api/src/model/review_reference_review_rel_snow_type.dart';
import 'package:lumisovellus_api/src/model/review_reference_review_rel_user_id.dart';
import 'package:lumisovellus_api/src/model/role_update.dart';
import 'package:lumisovellus_api/src/model/segment.dart';
import 'package:lumisovellus_api/src/model/segment_point.dart';
import 'package:lumisovellus_api/src/model/segment_update.dart';
import 'package:lumisovellus_api/src/model/segment_user_review.dart';
import 'package:lumisovellus_api/src/model/snow_condition.dart';
import 'package:lumisovellus_api/src/model/update_profile_request.dart';
import 'package:lumisovellus_api/src/model/user.dart';
import 'package:lumisovellus_api/src/model/user_review_observation.dart';

final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

  ReturnType deserialize<ReturnType, BaseType>(dynamic value, String targetType, {bool growable= true}) {
      switch (targetType) {
        case 'String':
          return '$value' as ReturnType;
        case 'int':
          return (value is int ? value : int.parse('$value')) as ReturnType;
        case 'bool':
          if (value is bool) {
            return value as ReturnType;
          }
          final valueString = '$value'.toLowerCase();
          return (valueString == 'true' || valueString == '1') as ReturnType;
        case 'double':
          return (value is double ? value : double.parse('$value')) as ReturnType;
        case 'AddSecondarySnowTypesRequest':
          return AddSecondarySnowTypesRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApiV1HelpRequestsIdHelpersGet200Response':
          return ApiV1HelpRequestsIdHelpersGet200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApiV1HelpRequestsIdHelpersGet200ResponseDataInner':
          return ApiV1HelpRequestsIdHelpersGet200ResponseDataInner.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApiV1HelpRequestsPost200Response':
          return ApiV1HelpRequestsPost200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApiV1HelpRequestsPost200ResponseData':
          return ApiV1HelpRequestsPost200ResponseData.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApiV1ObservationsGet200Response':
          return ApiV1ObservationsGet200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApiV1SegmentsGet200Response':
          return ApiV1SegmentsGet200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApiV1SegmentsIdGuideUpdatePost200Response':
          return ApiV1SegmentsIdGuideUpdatePost200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApiV1SegmentsIdGuideUpdatePost200ResponseData':
          return ApiV1SegmentsIdGuideUpdatePost200ResponseData.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApiV1SegmentsIdReviewsPostRequest':
          return ApiV1SegmentsIdReviewsPostRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApiV1SegmentsIdUpdatesGet200Response':
          return ApiV1SegmentsIdUpdatesGet200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApiV1SnowTypesGet200Response':
          return ApiV1SnowTypesGet200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApiV1SnowTypesPost201Response':
          return ApiV1SnowTypesPost201Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApiV1UsersDeviceIdLocationPost200Response':
          return ApiV1UsersDeviceIdLocationPost200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApiV1UsersDeviceIdLocationPost200ResponseData':
          return ApiV1UsersDeviceIdLocationPost200ResponseData.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApiV1UsersDeviceIdRoleGet200Response':
          return ApiV1UsersDeviceIdRoleGet200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApiV1UsersDeviceIdRoleGet200ResponseData':
          return ApiV1UsersDeviceIdRoleGet200ResponseData.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApiV1UsersGet200Response':
          return ApiV1UsersGet200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApiV1UsersIdPutRequest':
          return ApiV1UsersIdPutRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuthProfileGet200Response':
          return AuthProfileGet200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuthRegisterPost201Response':
          return AuthRegisterPost201Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuthResetPasswordPost200Response':
          return AuthResetPasswordPost200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuthResetPasswordPost200ResponseData':
          return AuthResetPasswordPost200ResponseData.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuthResetPasswordPost200ResponseMeta':
          return AuthResetPasswordPost200ResponseMeta.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuthResponse':
          return AuthResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuthResponseUser':
          return AuthResponseUser.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuthVerifyTokenGet200Response':
          return AuthVerifyTokenGet200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuthVerifyTokenGet200ResponseData':
          return AuthVerifyTokenGet200ResponseData.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuthVerifyTokenGet200ResponseDataUser':
          return AuthVerifyTokenGet200ResponseDataUser.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuthVerifyTokenGet200ResponseDataUserLastName':
          return AuthVerifyTokenGet200ResponseDataUserLastName.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BatteryUpdate':
          return BatteryUpdate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ChangePasswordRequest':
          return ChangePasswordRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CreateSnowTypeRequest':
          return CreateSnowTypeRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Creator':
          return Creator.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ErrorResponse':
          return ErrorResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ErrorResponseError':
          return ErrorResponseError.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ErrorResponseMeta':
          return ErrorResponseMeta.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GuideUpdateRequest':
          return GuideUpdateRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GuideUpdateRequestOutput':
          return GuideUpdateRequestOutput.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HealthGet200Response':
          return HealthGet200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HealthGet200ResponseMeta':
          return HealthGet200ResponseMeta.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HealthResponse':
          return HealthResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HelpRequest':
          return HelpRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HelpResponse':
          return HelpResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LocationUpdate':
          return LocationUpdate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LoginRequest':
          return LoginRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Observation':
          return Observation.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RefreshTokenRequest':
          return RefreshTokenRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RegisterRequest':
          return RegisterRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ResetPasswordRequest':
          return ResetPasswordRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReviewReference':
          return ReviewReference.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReviewReferenceNotes':
          return ReviewReferenceNotes.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReviewReferenceReviewRel':
          return ReviewReferenceReviewRel.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReviewReferenceReviewRelComment':
          return ReviewReferenceReviewRelComment.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReviewReferenceReviewRelHazards':
          return ReviewReferenceReviewRelHazards.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReviewReferenceReviewRelSecondarySnowType':
          return ReviewReferenceReviewRelSecondarySnowType.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReviewReferenceReviewRelSnowType':
          return ReviewReferenceReviewRelSnowType.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReviewReferenceReviewRelUserId':
          return ReviewReferenceReviewRelUserId.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RoleUpdate':
          return RoleUpdate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Segment':
          return Segment.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SegmentPoint':
          return SegmentPoint.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SegmentUpdate':
          return SegmentUpdate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SegmentUserReview':
          return SegmentUserReview.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SnowCondition':
          return SnowCondition.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UpdateProfileRequest':
          return UpdateProfileRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'User':
          return User.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserReviewObservation':
          return UserReviewObservation.fromJson(value as Map<String, dynamic>) as ReturnType;
        default:
          RegExpMatch? match;

          if (value is List && (match = _regList.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toList(growable: growable) as ReturnType;
          }
          if (value is Set && (match = _regSet.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toSet() as ReturnType;
          }
          if (value is Map && (match = _regMap.firstMatch(targetType)) != null) {
            targetType = match![1]!.trim(); // ignore: parameter_assignments
            return Map<String, BaseType>.fromIterables(
              value.keys as Iterable<String>,
              value.values.map((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable)),
            ) as ReturnType;
          }
          break;
    }
    throw Exception('Cannot deserialize');
  }