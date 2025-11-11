//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

// ignore: unused_import
import 'dart:convert';
import 'package:lumisovellus_api/src/deserialize.dart';
import 'package:dio/dio.dart';

import 'package:lumisovellus_api/src/model/api_v1_observations_get200_response.dart';
import 'package:lumisovellus_api/src/model/api_v1_segments_id_reviews_post_request.dart';
import 'package:lumisovellus_api/src/model/api_v1_snow_types_post201_response.dart';
import 'package:lumisovellus_api/src/model/error_response.dart';

class ReviewsApi {

  final Dio _dio;

  const ReviewsApi(this._dio);

  /// Get observations for all segments
  /// Retrieve observations (reviews and guide updates) for all segments from the last N days, grouped by segment. Supports pagination of segments.
  ///
  /// Parameters:
  /// * [days] - Number of days to look back for reviews and guide updates
  /// * [limit] - Maximum number of user reviews to return per segment
  /// * [page] - Page number for paginated results (segments)
  /// * [pageSize] - Number of segments per page
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ApiV1ObservationsGet200Response] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ApiV1ObservationsGet200Response>> apiV1ObservationsGet({ 
    String? days,
    String? limit,
    String? page,
    String? pageSize,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/observations';
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      if (days != null) r'days': days,
      if (limit != null) r'limit': limit,
      if (page != null) r'page': page,
      if (pageSize != null) r'pageSize': pageSize,
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ApiV1ObservationsGet200Response? _responseData;

    try {
final rawData = _response.data;
_responseData = rawData == null ? null : deserialize<ApiV1ObservationsGet200Response, ApiV1ObservationsGet200Response>(rawData, 'ApiV1ObservationsGet200Response', growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ApiV1ObservationsGet200Response>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// Create a review for a segment
  /// Submit a snow condition review for a specific segment
  ///
  /// Parameters:
  /// * [id] - Segment ID (UUID)
  /// * [apiV1SegmentsIdReviewsPostRequest] 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ApiV1SnowTypesPost201Response] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ApiV1SnowTypesPost201Response>> apiV1SegmentsIdReviewsPost({ 
    required String id,
    required ApiV1SegmentsIdReviewsPostRequest apiV1SegmentsIdReviewsPostRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/segments/{id}/reviews'.replaceAll('{' r'id' '}', id.toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'http',
            'scheme': 'bearer',
            'name': 'BearerAuth',
          },
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
_bodyData=jsonEncode(apiV1SegmentsIdReviewsPostRequest);
    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ApiV1SnowTypesPost201Response? _responseData;

    try {
final rawData = _response.data;
_responseData = rawData == null ? null : deserialize<ApiV1SnowTypesPost201Response, ApiV1SnowTypesPost201Response>(rawData, 'ApiV1SnowTypesPost201Response', growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ApiV1SnowTypesPost201Response>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

}
