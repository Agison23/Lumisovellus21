//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

// ignore: unused_import
import 'dart:convert';
import 'package:lumisovellus_api/src/deserialize.dart';
import 'package:dio/dio.dart';

import 'package:lumisovellus_api/src/model/api_v1_segments_id_updates_get200_response.dart';
import 'package:lumisovellus_api/src/model/error_response.dart';

class UpdatesApi {

  final Dio _dio;

  const UpdatesApi(this._dio);

  /// Get updates for segments
  /// Get updates filtered by updatedSince or time range; include review details.
  ///
  /// Parameters:
  /// * [days] - Number of days to look back (ignored if updatedSince/from/to provided)
  /// * [segmentId] - Filter updates by a specific segment ID
  /// * [updatedSince] - Return updates since this timestamp (ISO 8601)
  /// * [from] - Start of time range (ISO 8601). If provided, overrides days/updatedSince.
  /// * [to] - End of time range (ISO 8601). If provided, overrides days/updatedSince.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ApiV1SegmentsIdUpdatesGet200Response] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ApiV1SegmentsIdUpdatesGet200Response>> apiV1UpdatesGet({ 
    String? days,
    String? segmentId,
    DateTime? updatedSince,
    DateTime? from,
    DateTime? to,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/updates';
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
      if (segmentId != null) r'segmentId': segmentId,
      if (updatedSince != null) r'updatedSince': updatedSince,
      if (from != null) r'from': from,
      if (to != null) r'to': to,
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ApiV1SegmentsIdUpdatesGet200Response? _responseData;

    try {
final rawData = _response.data;
_responseData = rawData == null ? null : deserialize<ApiV1SegmentsIdUpdatesGet200Response, ApiV1SegmentsIdUpdatesGet200Response>(rawData, 'ApiV1SegmentsIdUpdatesGet200Response', growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ApiV1SegmentsIdUpdatesGet200Response>(
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
