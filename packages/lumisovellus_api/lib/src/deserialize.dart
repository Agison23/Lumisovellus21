import 'package:lumisovellus_api/src/model/add_secondary_snow_types_request.dart';
import 'package:lumisovellus_api/src/model/api_v1_observations_get200_response.dart';
import 'package:lumisovellus_api/src/model/api_v1_segments_get200_response.dart';
import 'package:lumisovellus_api/src/model/api_v1_segments_id_guide_update_post200_response.dart';
import 'package:lumisovellus_api/src/model/api_v1_segments_id_guide_update_post200_response_data.dart';
import 'package:lumisovellus_api/src/model/api_v1_segments_id_observations_get200_response.dart';
import 'package:lumisovellus_api/src/model/api_v1_segments_id_reviews_post_request.dart';
import 'package:lumisovellus_api/src/model/api_v1_snow_types_get200_response.dart';
import 'package:lumisovellus_api/src/model/api_v1_snow_types_id_secondary_post200_response.dart';
import 'package:lumisovellus_api/src/model/api_v1_snow_types_post201_response.dart';
import 'package:lumisovellus_api/src/model/api_v1_snow_types_primary_get200_response.dart';
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
import 'package:lumisovellus_api/src/model/auth_response.dart';
import 'package:lumisovellus_api/src/model/auth_response_user.dart';
import 'package:lumisovellus_api/src/model/auth_verify_token_get200_response.dart';
import 'package:lumisovellus_api/src/model/auth_verify_token_get200_response_data.dart';
import 'package:lumisovellus_api/src/model/auth_verify_token_get200_response_data_user.dart';
import 'package:lumisovellus_api/src/model/battery_update.dart';
import 'package:lumisovellus_api/src/model/change_password_request.dart';
import 'package:lumisovellus_api/src/model/create_snow_type_request.dart';
import 'package:lumisovellus_api/src/model/error_response.dart';
import 'package:lumisovellus_api/src/model/error_response_error.dart';
import 'package:lumisovellus_api/src/model/error_response_meta.dart';
import 'package:lumisovellus_api/src/model/guide_update_request.dart';
import 'package:lumisovellus_api/src/model/guide_update_request_output.dart';
import 'package:lumisovellus_api/src/model/health_get200_response.dart';
import 'package:lumisovellus_api/src/model/health_get200_response_meta.dart';
import 'package:lumisovellus_api/src/model/health_response.dart';
import 'package:lumisovellus_api/src/model/help_event_acceptance.dart';
import 'package:lumisovellus_api/src/model/help_event_create.dart';
import 'package:lumisovellus_api/src/model/help_event_location.dart';
import 'package:lumisovellus_api/src/model/help_event_location_output.dart';
import 'package:lumisovellus_api/src/model/help_event_participation.dart';
import 'package:lumisovellus_api/src/model/help_event_rescuee.dart';
import 'package:lumisovellus_api/src/model/help_event_rescuee_view.dart';
import 'package:lumisovellus_api/src/model/help_event_rescuer_view.dart';
import 'package:lumisovellus_api/src/model/help_event_status_update.dart';
import 'package:lumisovellus_api/src/model/help_event_summary.dart';
import 'package:lumisovellus_api/src/model/help_event_user_status.dart';
import 'package:lumisovellus_api/src/model/help_events_event_id_acceptance_post200_response.dart';
import 'package:lumisovellus_api/src/model/help_events_event_id_view_get200_response.dart';
import 'package:lumisovellus_api/src/model/help_events_event_id_view_get200_response_data.dart';
import 'package:lumisovellus_api/src/model/help_events_nearby_get200_response.dart';
import 'package:lumisovellus_api/src/model/help_events_post201_response.dart';
import 'package:lumisovellus_api/src/model/location_update.dart';
import 'package:lumisovellus_api/src/model/login_request.dart';
import 'package:lumisovellus_api/src/model/observation.dart';
import 'package:lumisovellus_api/src/model/primary_snow_type_with_secondaries.dart';
import 'package:lumisovellus_api/src/model/refresh_token_request.dart';
import 'package:lumisovellus_api/src/model/register_request.dart';
import 'package:lumisovellus_api/src/model/reset_password_request.dart';
import 'package:lumisovellus_api/src/model/role_update.dart';
import 'package:lumisovellus_api/src/model/segment.dart';
import 'package:lumisovellus_api/src/model/segment_point.dart';
import 'package:lumisovellus_api/src/model/segment_user_review.dart';
import 'package:lumisovellus_api/src/model/snow_type.dart';
import 'package:lumisovellus_api/src/model/update_profile_request.dart';
import 'package:lumisovellus_api/src/model/user.dart';
import 'package:lumisovellus_api/src/model/user_review_observation.dart';
import 'package:lumisovellus_api/src/model/weather_average_get200_response.dart';
import 'package:lumisovellus_api/src/model/weather_filter_days_get200_response.dart';
import 'package:lumisovellus_api/src/model/weather_filter_days_response.dart';
import 'package:lumisovellus_api/src/model/weather_filter_days_response_matches_inner.dart';
import 'package:lumisovellus_api/src/model/weather_location.dart';
import 'package:lumisovellus_api/src/model/weather_metric.dart';
import 'package:lumisovellus_api/src/model/weather_period.dart';

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
        case 'ApiV1ObservationsGet200Response':
          return ApiV1ObservationsGet200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApiV1SegmentsGet200Response':
          return ApiV1SegmentsGet200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApiV1SegmentsIdGuideUpdatePost200Response':
          return ApiV1SegmentsIdGuideUpdatePost200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApiV1SegmentsIdGuideUpdatePost200ResponseData':
          return ApiV1SegmentsIdGuideUpdatePost200ResponseData.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApiV1SegmentsIdObservationsGet200Response':
          return ApiV1SegmentsIdObservationsGet200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApiV1SegmentsIdReviewsPostRequest':
          return ApiV1SegmentsIdReviewsPostRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApiV1SnowTypesGet200Response':
          return ApiV1SnowTypesGet200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApiV1SnowTypesIdSecondaryPost200Response':
          return ApiV1SnowTypesIdSecondaryPost200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApiV1SnowTypesPost201Response':
          return ApiV1SnowTypesPost201Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApiV1SnowTypesPrimaryGet200Response':
          return ApiV1SnowTypesPrimaryGet200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
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
        case 'BatteryUpdate':
          return BatteryUpdate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ChangePasswordRequest':
          return ChangePasswordRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CreateSnowTypeRequest':
          return CreateSnowTypeRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
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
        case 'Hazard':
          
          
        case 'HealthGet200Response':
          return HealthGet200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HealthGet200ResponseMeta':
          return HealthGet200ResponseMeta.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HealthResponse':
          return HealthResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HelpEventAcceptance':
          return HelpEventAcceptance.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HelpEventCreate':
          return HelpEventCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HelpEventLocation':
          return HelpEventLocation.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HelpEventLocationOutput':
          return HelpEventLocationOutput.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HelpEventParticipation':
          return HelpEventParticipation.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HelpEventRescuee':
          return HelpEventRescuee.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HelpEventRescueeView':
          return HelpEventRescueeView.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HelpEventRescuerView':
          return HelpEventRescuerView.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HelpEventStatusUpdate':
          return HelpEventStatusUpdate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HelpEventSummary':
          return HelpEventSummary.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HelpEventUserStatus':
          return HelpEventUserStatus.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HelpEventsEventIdAcceptancePost200Response':
          return HelpEventsEventIdAcceptancePost200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HelpEventsEventIdViewGet200Response':
          return HelpEventsEventIdViewGet200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HelpEventsEventIdViewGet200ResponseData':
          return HelpEventsEventIdViewGet200ResponseData.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HelpEventsNearbyGet200Response':
          return HelpEventsNearbyGet200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HelpEventsPost201Response':
          return HelpEventsPost201Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LocationUpdate':
          return LocationUpdate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LoginRequest':
          return LoginRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Observation':
          return Observation.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PrimarySnowTypeWithSecondaries':
          return PrimarySnowTypeWithSecondaries.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RefreshTokenRequest':
          return RefreshTokenRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RegisterRequest':
          return RegisterRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ResetPasswordRequest':
          return ResetPasswordRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RoleUpdate':
          return RoleUpdate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Segment':
          return Segment.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SegmentPoint':
          return SegmentPoint.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SegmentUserReview':
          return SegmentUserReview.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SnowType':
          return SnowType.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UpdateProfileRequest':
          return UpdateProfileRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'User':
          return User.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserReviewObservation':
          return UserReviewObservation.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'WeatherAverageGet200Response':
          return WeatherAverageGet200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'WeatherFilterDaysGet200Response':
          return WeatherFilterDaysGet200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'WeatherFilterDaysResponse':
          return WeatherFilterDaysResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'WeatherFilterDaysResponseMatchesInner':
          return WeatherFilterDaysResponseMatchesInner.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'WeatherLocation':
          return WeatherLocation.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'WeatherMetric':
          return WeatherMetric.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'WeatherPeriod':
          return WeatherPeriod.fromJson(value as Map<String, dynamic>) as ReturnType;
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