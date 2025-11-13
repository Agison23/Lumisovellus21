# lumisovellus_api.api.HelpRequestsApi

## Load the API package
```dart
import 'package:lumisovellus_api/api.dart';
```

All URIs are relative to *http://localhost:3001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1HelpRequestsGet**](HelpRequestsApi.md#apiv1helprequestsget) | **GET** /api/v1/help-requests | Get help requests
[**apiV1HelpRequestsIdHelpersGet**](HelpRequestsApi.md#apiv1helprequestsidhelpersget) | **GET** /api/v1/help-requests/{id}/helpers | Get users who can help with a specific help request
[**apiV1HelpRequestsPost**](HelpRequestsApi.md#apiv1helprequestspost) | **POST** /api/v1/help-requests | Create help request
[**apiV1HelpResponsesPost**](HelpRequestsApi.md#apiv1helpresponsespost) | **POST** /api/v1/help-responses | Update help response


# **apiV1HelpRequestsGet**
> ApiV1SnowTypesGet200Response apiV1HelpRequestsGet()

Get help requests

Retrieve all help requests for rescue interface

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getHelpRequestsApi();

try {
    final response = api.apiV1HelpRequestsGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling HelpRequestsApi->apiV1HelpRequestsGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ApiV1SnowTypesGet200Response**](ApiV1SnowTypesGet200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1HelpRequestsIdHelpersGet**
> ApiV1HelpRequestsIdHelpersGet200Response apiV1HelpRequestsIdHelpersGet(id)

Get users who can help with a specific help request

Retrieve all users who have been notified about a help request with their status and distance

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getHelpRequestsApi();
final String id = 550e8400-e29b-41d4-a716-446655440000; // String | Help request ID

try {
    final response = api.apiV1HelpRequestsIdHelpersGet(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling HelpRequestsApi->apiV1HelpRequestsIdHelpersGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Help request ID | 

### Return type

[**ApiV1HelpRequestsIdHelpersGet200Response**](ApiV1HelpRequestsIdHelpersGet200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1HelpRequestsPost**
> ApiV1HelpRequestsPost200Response apiV1HelpRequestsPost(helpRequest)

Create help request

Create a help request for emergency or assistance

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getHelpRequestsApi();
final HelpRequest helpRequest = ; // HelpRequest | 

try {
    final response = api.apiV1HelpRequestsPost(helpRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling HelpRequestsApi->apiV1HelpRequestsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **helpRequest** | [**HelpRequest**](HelpRequest.md)|  | 

### Return type

[**ApiV1HelpRequestsPost200Response**](ApiV1HelpRequestsPost200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1HelpResponsesPost**
> ApiV1UsersDeviceIdLocationPost200Response apiV1HelpResponsesPost(helpResponse)

Update help response

Update the response status for a help request

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getHelpRequestsApi();
final HelpResponse helpResponse = ; // HelpResponse | 

try {
    final response = api.apiV1HelpResponsesPost(helpResponse);
    print(response);
} catch on DioException (e) {
    print('Exception when calling HelpRequestsApi->apiV1HelpResponsesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **helpResponse** | [**HelpResponse**](HelpResponse.md)|  | 

### Return type

[**ApiV1UsersDeviceIdLocationPost200Response**](ApiV1UsersDeviceIdLocationPost200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

