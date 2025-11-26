# lumisovellus_api.api.ReviewsApi

## Load the API package
```dart
import 'package:lumisovellus_api/api.dart';
```

All URIs are relative to *http://localhost:3001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1ObservationsGet**](ReviewsApi.md#apiv1observationsget) | **GET** /api/v1/observations | Get observations for all segments
[**apiV1SegmentsIdObservationsGet**](ReviewsApi.md#apiv1segmentsidobservationsget) | **GET** /api/v1/segments/{id}/observations | Get observations for a specific segment
[**apiV1SegmentsIdReviewsPost**](ReviewsApi.md#apiv1segmentsidreviewspost) | **POST** /api/v1/segments/{id}/reviews | Create a review for a segment


# **apiV1ObservationsGet**
> ApiV1ObservationsGet200Response apiV1ObservationsGet(days, limit, page, pageSize)

Get observations for all segments

Retrieve observations (reviews and guide updates) for all segments from the last N days, grouped by segment. Supports pagination of segments.

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getReviewsApi();
final String days = 3; // String | Number of days to look back for reviews and guide updates
final String limit = 3; // String | Maximum number of user reviews to return per segment
final String page = 1; // String | Page number for paginated results (segments)
final String pageSize = 20; // String | Number of segments per page

try {
    final response = api.apiV1ObservationsGet(days, limit, page, pageSize);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ReviewsApi->apiV1ObservationsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **days** | **String**| Number of days to look back for reviews and guide updates | [optional] 
 **limit** | **String**| Maximum number of user reviews to return per segment | [optional] 
 **page** | **String**| Page number for paginated results (segments) | [optional] 
 **pageSize** | **String**| Number of segments per page | [optional] 

### Return type

[**ApiV1ObservationsGet200Response**](ApiV1ObservationsGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1SegmentsIdObservationsGet**
> ApiV1SegmentsIdObservationsGet200Response apiV1SegmentsIdObservationsGet(id, days, limit)

Get observations for a specific segment

Retrieve guide updates and user reviews for a specific segment within the requested time window.

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getReviewsApi();
final String id = 550e8400-e29b-41d4-a716-446655440000; // String | Segment ID (UUID)
final String days = 3; // String | Number of days to look back for this segment
final String limit = 3; // String | Maximum number of user reviews to include

try {
    final response = api.apiV1SegmentsIdObservationsGet(id, days, limit);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ReviewsApi->apiV1SegmentsIdObservationsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Segment ID (UUID) | 
 **days** | **String**| Number of days to look back for this segment | [optional] 
 **limit** | **String**| Maximum number of user reviews to include | [optional] 

### Return type

[**ApiV1SegmentsIdObservationsGet200Response**](ApiV1SegmentsIdObservationsGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1SegmentsIdReviewsPost**
> ApiV1SegmentsIdReviewsPost201Response apiV1SegmentsIdReviewsPost(id, apiV1SegmentsIdReviewsPostRequest)

Create a review for a segment

Submit a snow condition review for a specific segment

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getReviewsApi();
final String id = 550e8400-e29b-41d4-a716-446655440000; // String | Segment ID (UUID)
final ApiV1SegmentsIdReviewsPostRequest apiV1SegmentsIdReviewsPostRequest = ; // ApiV1SegmentsIdReviewsPostRequest | 

try {
    final response = api.apiV1SegmentsIdReviewsPost(id, apiV1SegmentsIdReviewsPostRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ReviewsApi->apiV1SegmentsIdReviewsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Segment ID (UUID) | 
 **apiV1SegmentsIdReviewsPostRequest** | [**ApiV1SegmentsIdReviewsPostRequest**](ApiV1SegmentsIdReviewsPostRequest.md)|  | 

### Return type

[**ApiV1SegmentsIdReviewsPost201Response**](ApiV1SegmentsIdReviewsPost201Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

