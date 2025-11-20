//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

// ignore: unused_import
import 'dart:convert';
import 'package:lumisovellus_api/src/deserialize.dart';
import 'package:dio/dio.dart';

import 'package:lumisovellus_api/src/model/api_v1_segments_get200_response.dart';
import 'package:lumisovellus_api/src/model/api_v1_segments_id_guide_update_post200_response.dart';
import 'package:lumisovellus_api/src/model/error_response.dart';
import 'package:lumisovellus_api/src/model/guide_update_request.dart';

class SegmentsApi {

  final Dio _dio;

  const SegmentsApi(this._dio);

  /// Get all segments
  /// Retrieve all ski segments with their coordinates and terrain information. Supports filtering by bounding box, search, and updatedSince.
  ///
  /// Parameters:
  /// * [bbox] - Bounding box to filter segments (format: \"minLat,minLng,maxLat,maxLng\")
  /// * [minLat] - Minimum latitude of bounding box
  /// * [minLng] - Minimum longitude of bounding box
  /// * [maxLat] - Maximum latitude of bounding box
  /// * [maxLng] - Maximum longitude of bounding box
  /// * [search] - Search term to filter segments by name
  /// * [updatedSince] - Return only segments updated since this date (ISO 8601 format)
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ApiV1SegmentsGet200Response] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ApiV1SegmentsGet200Response>> apiV1SegmentsGet({ 
    String? bbox,
    String? minLat,
    String? minLng,
    String? maxLat,
    String? maxLng,
    String? search,
    DateTime? updatedSince,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/segments';
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
      if (bbox != null) r'bbox': bbox,
      if (minLat != null) r'minLat': minLat,
      if (minLng != null) r'minLng': minLng,
      if (maxLat != null) r'maxLat': maxLat,
      if (maxLng != null) r'maxLng': maxLng,
      if (search != null) r'search': search,
      if (updatedSince != null) r'updatedSince': updatedSince,
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ApiV1SegmentsGet200Response? _responseData;

    try {
final rawData = _response.data;
_responseData = rawData == null ? null : deserialize<ApiV1SegmentsGet200Response, ApiV1SegmentsGet200Response>(rawData, 'ApiV1SegmentsGet200Response', growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ApiV1SegmentsGet200Response>(
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

  /// Create or update a guide update for a segment (Admin only)
  /// Creates a new guide update or updates the existing one for a segment. Only admins can create guide updates.
  ///
  /// Parameters:
  /// * [id] - Segment ID (UUID)
  /// * [guideUpdateRequest] 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ApiV1SegmentsIdGuideUpdatePost200Response] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ApiV1SegmentsIdGuideUpdatePost200Response>> apiV1SegmentsIdGuideUpdatePost({ 
    required String id,
    required GuideUpdateRequest guideUpdateRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/segments/{id}/guideUpdate'.replaceAll('{' r'id' '}', id.toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
_bodyData=jsonEncode(guideUpdateRequest);
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

    ApiV1SegmentsIdGuideUpdatePost200Response? _responseData;

    try {
final rawData = _response.data;
_responseData = rawData == null ? null : deserialize<ApiV1SegmentsIdGuideUpdatePost200Response, ApiV1SegmentsIdGuideUpdatePost200Response>(rawData, 'ApiV1SegmentsIdGuideUpdatePost200Response', growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ApiV1SegmentsIdGuideUpdatePost200Response>(
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
