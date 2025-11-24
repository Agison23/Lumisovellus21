# lumisovellus_api.api.UsersApi

## Load the API package
```dart
import 'package:lumisovellus_api/api.dart';
```

All URIs are relative to *http://localhost:3001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1UsersDeviceIdBatteryPost**](UsersApi.md#apiv1usersdeviceidbatterypost) | **POST** /api/v1/users/{deviceId}/battery | Update battery status
[**apiV1UsersDeviceIdLocationPost**](UsersApi.md#apiv1usersdeviceidlocationpost) | **POST** /api/v1/users/{deviceId}/location | Update mobile user location
[**apiV1UsersDeviceIdRoleGet**](UsersApi.md#apiv1usersdeviceidroleget) | **GET** /api/v1/users/{deviceId}/role | Get user role
[**apiV1UsersDeviceIdRolePost**](UsersApi.md#apiv1usersdeviceidrolepost) | **POST** /api/v1/users/{deviceId}/role | Update user role
[**apiV1UsersGet**](UsersApi.md#apiv1usersget) | **GET** /api/v1/users | List all users
[**apiV1UsersIdDelete**](UsersApi.md#apiv1usersiddelete) | **DELETE** /api/v1/users/{id} | Delete a user
[**apiV1UsersIdPut**](UsersApi.md#apiv1usersidput) | **PUT** /api/v1/users/{id} | Update a user
[**apiV1UsersMeGet**](UsersApi.md#apiv1usersmeget) | **GET** /api/v1/users/me | Get current user details


# **apiV1UsersDeviceIdBatteryPost**
> ApiV1UsersDeviceIdLocationPost200Response apiV1UsersDeviceIdBatteryPost(deviceId, batteryUpdate)

Update battery status

Update the battery status for a mobile user

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getUsersApi();
final String deviceId = device123; // String | Device identifier
final BatteryUpdate batteryUpdate = ; // BatteryUpdate | 

try {
    final response = api.apiV1UsersDeviceIdBatteryPost(deviceId, batteryUpdate);
    print(response);
} catch on DioException (e) {
    print('Exception when calling UsersApi->apiV1UsersDeviceIdBatteryPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deviceId** | **String**| Device identifier | 
 **batteryUpdate** | [**BatteryUpdate**](BatteryUpdate.md)|  | 

### Return type

[**ApiV1UsersDeviceIdLocationPost200Response**](ApiV1UsersDeviceIdLocationPost200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1UsersDeviceIdLocationPost**
> ApiV1UsersDeviceIdLocationPost200Response apiV1UsersDeviceIdLocationPost(deviceId, locationUpdate)

Update mobile user location

Update or create mobile user location data for tracking and rescue purposes

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getUsersApi();
final String deviceId = device123; // String | Device identifier
final LocationUpdate locationUpdate = ; // LocationUpdate | 

try {
    final response = api.apiV1UsersDeviceIdLocationPost(deviceId, locationUpdate);
    print(response);
} catch on DioException (e) {
    print('Exception when calling UsersApi->apiV1UsersDeviceIdLocationPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deviceId** | **String**| Device identifier | 
 **locationUpdate** | [**LocationUpdate**](LocationUpdate.md)|  | 

### Return type

[**ApiV1UsersDeviceIdLocationPost200Response**](ApiV1UsersDeviceIdLocationPost200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1UsersDeviceIdRoleGet**
> ApiV1UsersDeviceIdRoleGet200Response apiV1UsersDeviceIdRoleGet(deviceId)

Get user role

Retrieve the role and permissions for a mobile user

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getUsersApi();
final String deviceId = device123; // String | Device identifier

try {
    final response = api.apiV1UsersDeviceIdRoleGet(deviceId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling UsersApi->apiV1UsersDeviceIdRoleGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deviceId** | **String**| Device identifier | 

### Return type

[**ApiV1UsersDeviceIdRoleGet200Response**](ApiV1UsersDeviceIdRoleGet200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1UsersDeviceIdRolePost**
> ApiV1UsersDeviceIdRoleGet200Response apiV1UsersDeviceIdRolePost(deviceId, roleUpdate)

Update user role

Update the role for a mobile user

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getUsersApi();
final String deviceId = device123; // String | Device identifier
final RoleUpdate roleUpdate = ; // RoleUpdate | 

try {
    final response = api.apiV1UsersDeviceIdRolePost(deviceId, roleUpdate);
    print(response);
} catch on DioException (e) {
    print('Exception when calling UsersApi->apiV1UsersDeviceIdRolePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deviceId** | **String**| Device identifier | 
 **roleUpdate** | [**RoleUpdate**](RoleUpdate.md)|  | 

### Return type

[**ApiV1UsersDeviceIdRoleGet200Response**](ApiV1UsersDeviceIdRoleGet200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1UsersGet**
> ApiV1UsersGet200Response apiV1UsersGet()

List all users

Get a list of all users (admin only)

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getUsersApi();

try {
    final response = api.apiV1UsersGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling UsersApi->apiV1UsersGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ApiV1UsersGet200Response**](ApiV1UsersGet200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1UsersIdDelete**
> AuthResetPasswordPost200Response apiV1UsersIdDelete(id)

Delete a user

Delete a user and all related data (admin only)

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getUsersApi();
final String id = 550e8400-e29b-41d4-a716-446655440001; // String | User ID

try {
    final response = api.apiV1UsersIdDelete(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling UsersApi->apiV1UsersIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| User ID | 

### Return type

[**AuthResetPasswordPost200Response**](AuthResetPasswordPost200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1UsersIdPut**
> AuthProfileGet200Response apiV1UsersIdPut(id, updateUserRequest)

Update a user

Update user information (admin only)

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getUsersApi();
final String id = 550e8400-e29b-41d4-a716-446655440001; // String | User ID
final UpdateUserRequest updateUserRequest = ; // UpdateUserRequest | 

try {
    final response = api.apiV1UsersIdPut(id, updateUserRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling UsersApi->apiV1UsersIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| User ID | 
 **updateUserRequest** | [**UpdateUserRequest**](UpdateUserRequest.md)|  | 

### Return type

[**AuthProfileGet200Response**](AuthProfileGet200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1UsersMeGet**
> AuthProfileGet200Response apiV1UsersMeGet()

Get current user details

Get details of the currently authenticated user

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getUsersApi();

try {
    final response = api.apiV1UsersMeGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling UsersApi->apiV1UsersMeGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AuthProfileGet200Response**](AuthProfileGet200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

