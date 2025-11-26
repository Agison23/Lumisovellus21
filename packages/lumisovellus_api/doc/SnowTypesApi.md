# lumisovellus_api.api.SnowTypesApi

## Load the API package
```dart
import 'package:lumisovellus_api/api.dart';
```

All URIs are relative to *http://localhost:3001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1SnowTypesGet**](SnowTypesApi.md#apiv1snowtypesget) | **GET** /api/v1/snow-types | Get all snow types (primary and secondary)
[**apiV1SnowTypesIdSecondaryPost**](SnowTypesApi.md#apiv1snowtypesidsecondarypost) | **POST** /api/v1/snow-types/{id}/secondary | Add secondary snow types to a snow type
[**apiV1SnowTypesPost**](SnowTypesApi.md#apiv1snowtypespost) | **POST** /api/v1/snow-types | Create a new snow type
[**apiV1SnowTypesPrimaryGet**](SnowTypesApi.md#apiv1snowtypesprimaryget) | **GET** /api/v1/snow-types/primary | Get all primary snow types


# **apiV1SnowTypesGet**
> ApiV1SnowTypesGet200Response apiV1SnowTypesGet()

Get all snow types (primary and secondary)

Retrieve all snow types including both primary and secondary snow types in a flat list.

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getSnowTypesApi();

try {
    final response = api.apiV1SnowTypesGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling SnowTypesApi->apiV1SnowTypesGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ApiV1SnowTypesGet200Response**](ApiV1SnowTypesGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1SnowTypesIdSecondaryPost**
> ApiV1SnowTypesPost201Response apiV1SnowTypesIdSecondaryPost(id, addSecondarySnowTypesRequest)

Add secondary snow types to a snow type

Associate one or more existing snow types as secondary types for the specified snow type. All entities are SnowTypes - \"secondary\" refers only to the relationship. Requires authentication and admin role.

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getSnowTypesApi();
final String id = 550e8400-e29b-41d4-a716-446655440000; // String | Snow type ID (UUID)
final AddSecondarySnowTypesRequest addSecondarySnowTypesRequest = {"secondarySnowTypeIds":["550e8400-e29b-41d4-a716-446655440001","550e8400-e29b-41d4-a716-446655440002"]}; // AddSecondarySnowTypesRequest | 

try {
    final response = api.apiV1SnowTypesIdSecondaryPost(id, addSecondarySnowTypesRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling SnowTypesApi->apiV1SnowTypesIdSecondaryPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Snow type ID (UUID) | 
 **addSecondarySnowTypesRequest** | [**AddSecondarySnowTypesRequest**](AddSecondarySnowTypesRequest.md)|  | 

### Return type

[**ApiV1SnowTypesPost201Response**](ApiV1SnowTypesPost201Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1SnowTypesPost**
> ApiV1SnowTypesPost201Response apiV1SnowTypesPost(createSnowTypeRequest)

Create a new snow type

Create a new snow type with the provided information. Requires authentication and admin role.

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getSnowTypesApi();
final CreateSnowTypeRequest createSnowTypeRequest = {"name":"Powder","colour":"#FFFFFF","skiability":5,"primarySnowTypeId":null,"explanation":"Fresh powder snow"}; // CreateSnowTypeRequest | 

try {
    final response = api.apiV1SnowTypesPost(createSnowTypeRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling SnowTypesApi->apiV1SnowTypesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createSnowTypeRequest** | [**CreateSnowTypeRequest**](CreateSnowTypeRequest.md)|  | 

### Return type

[**ApiV1SnowTypesPost201Response**](ApiV1SnowTypesPost201Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1SnowTypesPrimaryGet**
> ApiV1SnowTypesPrimaryGet200Response apiV1SnowTypesPrimaryGet()

Get all primary snow types

Retrieve all primary snow types (primarySnowTypeId: null) for reviews. Each primary snow type includes an array of its secondary snow types.

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getSnowTypesApi();

try {
    final response = api.apiV1SnowTypesPrimaryGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling SnowTypesApi->apiV1SnowTypesPrimaryGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ApiV1SnowTypesPrimaryGet200Response**](ApiV1SnowTypesPrimaryGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

