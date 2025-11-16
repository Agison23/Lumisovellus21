# lumisovellus_api.api.SegmentsApi

## Load the API package
```dart
import 'package:lumisovellus_api/api.dart';
```

All URIs are relative to *http://localhost:3001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1SegmentsGet**](SegmentsApi.md#apiv1segmentsget) | **GET** /api/v1/segments | Get all segments
[**apiV1SegmentsIdGuideUpdatePost**](SegmentsApi.md#apiv1segmentsidguideupdatepost) | **POST** /api/v1/segments/{id}/guideUpdate | Create or update a guide update for a segment (Admin only)


# **apiV1SegmentsGet**
> ApiV1SegmentsGet200Response apiV1SegmentsGet(bbox, minLat, minLng, maxLat, maxLng, search, updatedSince)

Get all segments

Retrieve all ski segments with their coordinates and terrain information. Supports filtering by bounding box, search, and updatedSince.

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getSegmentsApi();
final String bbox = 64.0,25.0,66.0,30.0; // String | Bounding box to filter segments (format: \"minLat,minLng,maxLat,maxLng\")
final String minLat = 64.0; // String | Minimum latitude of bounding box
final String minLng = 25.0; // String | Minimum longitude of bounding box
final String maxLat = 66.0; // String | Maximum latitude of bounding box
final String maxLng = 30.0; // String | Maximum longitude of bounding box
final String search = tunturi; // String | Search term to filter segments by name
final DateTime updatedSince = 2024-01-01T00:00Z; // DateTime | Return only segments updated since this date (ISO 8601 format)

try {
    final response = api.apiV1SegmentsGet(bbox, minLat, minLng, maxLat, maxLng, search, updatedSince);
    print(response);
} catch on DioException (e) {
    print('Exception when calling SegmentsApi->apiV1SegmentsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bbox** | **String**| Bounding box to filter segments (format: \"minLat,minLng,maxLat,maxLng\") | [optional] 
 **minLat** | **String**| Minimum latitude of bounding box | [optional] 
 **minLng** | **String**| Minimum longitude of bounding box | [optional] 
 **maxLat** | **String**| Maximum latitude of bounding box | [optional] 
 **maxLng** | **String**| Maximum longitude of bounding box | [optional] 
 **search** | **String**| Search term to filter segments by name | [optional] 
 **updatedSince** | **DateTime**| Return only segments updated since this date (ISO 8601 format) | [optional] 

### Return type

[**ApiV1SegmentsGet200Response**](ApiV1SegmentsGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1SegmentsIdGuideUpdatePost**
> ApiV1SegmentsIdGuideUpdatePost200Response apiV1SegmentsIdGuideUpdatePost(id, guideUpdateRequest)

Create or update a guide update for a segment (Admin only)

Creates a new guide update or updates the existing one for a segment. Only admins can create guide updates.

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getSegmentsApi();
final String id = 550e8400-e29b-41d4-a716-446655440000; // String | Segment ID (UUID)
final GuideUpdateRequest guideUpdateRequest = ; // GuideUpdateRequest | 

try {
    final response = api.apiV1SegmentsIdGuideUpdatePost(id, guideUpdateRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling SegmentsApi->apiV1SegmentsIdGuideUpdatePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Segment ID (UUID) | 
 **guideUpdateRequest** | [**GuideUpdateRequest**](GuideUpdateRequest.md)|  | 

### Return type

[**ApiV1SegmentsIdGuideUpdatePost200Response**](ApiV1SegmentsIdGuideUpdatePost200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

