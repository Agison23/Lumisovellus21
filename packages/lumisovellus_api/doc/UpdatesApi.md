# lumisovellus_api.api.UpdatesApi

## Load the API package
```dart
import 'package:lumisovellus_api/api.dart';
```

All URIs are relative to *http://localhost:3001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1UpdatesGet**](UpdatesApi.md#apiv1updatesget) | **GET** /api/v1/updates | Get updates for segments


# **apiV1UpdatesGet**
> ApiV1SegmentsIdUpdatesGet200Response apiV1UpdatesGet(days, segmentId, updatedSince, from, to)

Get updates for segments

Get updates filtered by updatedSince or time range; include review details.

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getUpdatesApi();
final String days = 3; // String | Number of days to look back (ignored if updatedSince/from/to provided)
final String segmentId = 550e8400-e29b-41d4-a716-446655440000; // String | Filter updates by a specific segment ID
final DateTime updatedSince = 2024-01-01T00:00Z; // DateTime | Return updates since this timestamp (ISO 8601)
final DateTime from = 2024-01-01T00:00Z; // DateTime | Start of time range (ISO 8601). If provided, overrides days/updatedSince.
final DateTime to = 2024-01-31T23:59:59Z; // DateTime | End of time range (ISO 8601). If provided, overrides days/updatedSince.

try {
    final response = api.apiV1UpdatesGet(days, segmentId, updatedSince, from, to);
    print(response);
} catch on DioException (e) {
    print('Exception when calling UpdatesApi->apiV1UpdatesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **days** | **String**| Number of days to look back (ignored if updatedSince/from/to provided) | [optional] 
 **segmentId** | **String**| Filter updates by a specific segment ID | [optional] 
 **updatedSince** | **DateTime**| Return updates since this timestamp (ISO 8601) | [optional] 
 **from** | **DateTime**| Start of time range (ISO 8601). If provided, overrides days/updatedSince. | [optional] 
 **to** | **DateTime**| End of time range (ISO 8601). If provided, overrides days/updatedSince. | [optional] 

### Return type

[**ApiV1SegmentsIdUpdatesGet200Response**](ApiV1SegmentsIdUpdatesGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

