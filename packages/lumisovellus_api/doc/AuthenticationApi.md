# lumisovellus_api.api.AuthenticationApi

## Load the API package
```dart
import 'package:lumisovellus_api/api.dart';
```

All URIs are relative to *http://localhost:3001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**authChangePasswordPut**](AuthenticationApi.md#authchangepasswordput) | **PUT** /auth/change-password | Change user password
[**authLoginPost**](AuthenticationApi.md#authloginpost) | **POST** /auth/login | Login user
[**authLogoutPost**](AuthenticationApi.md#authlogoutpost) | **POST** /auth/logout | Logout user
[**authProfileGet**](AuthenticationApi.md#authprofileget) | **GET** /auth/profile | Get user profile
[**authProfilePut**](AuthenticationApi.md#authprofileput) | **PUT** /auth/profile | Update user profile
[**authRefreshTokenPost**](AuthenticationApi.md#authrefreshtokenpost) | **POST** /auth/refresh-token | Refresh access token
[**authRegisterPost**](AuthenticationApi.md#authregisterpost) | **POST** /auth/register | Register a new user
[**authResetPasswordPost**](AuthenticationApi.md#authresetpasswordpost) | **POST** /auth/reset-password | Request password reset
[**authVerifyTokenGet**](AuthenticationApi.md#authverifytokenget) | **GET** /auth/verify-token | Verify token validity


# **authChangePasswordPut**
> AuthResetPasswordPost200Response authChangePasswordPut(changePasswordRequest)

Change user password

Change the authenticated user's password

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getAuthenticationApi();
final ChangePasswordRequest changePasswordRequest = ; // ChangePasswordRequest | 

try {
    final response = api.authChangePasswordPut(changePasswordRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthenticationApi->authChangePasswordPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **changePasswordRequest** | [**ChangePasswordRequest**](ChangePasswordRequest.md)|  | 

### Return type

[**AuthResetPasswordPost200Response**](AuthResetPasswordPost200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authLoginPost**
> AuthRegisterPost201Response authLoginPost(loginRequest)

Login user

Authenticate user with email and password

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getAuthenticationApi();
final LoginRequest loginRequest = ; // LoginRequest | 

try {
    final response = api.authLoginPost(loginRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthenticationApi->authLoginPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loginRequest** | [**LoginRequest**](LoginRequest.md)|  | 

### Return type

[**AuthRegisterPost201Response**](AuthRegisterPost201Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authLogoutPost**
> AuthResetPasswordPost200Response authLogoutPost()

Logout user

Logout the authenticated user

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getAuthenticationApi();

try {
    final response = api.authLogoutPost();
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthenticationApi->authLogoutPost: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AuthResetPasswordPost200Response**](AuthResetPasswordPost200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authProfileGet**
> AuthProfileGet200Response authProfileGet()

Get user profile

Retrieve the authenticated user's profile information

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getAuthenticationApi();

try {
    final response = api.authProfileGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthenticationApi->authProfileGet: $e\n');
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

# **authProfilePut**
> AuthProfileGet200Response authProfilePut(updateProfileRequest)

Update user profile

Update the authenticated user's profile information

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getAuthenticationApi();
final UpdateProfileRequest updateProfileRequest = ; // UpdateProfileRequest | 

try {
    final response = api.authProfilePut(updateProfileRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthenticationApi->authProfilePut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updateProfileRequest** | [**UpdateProfileRequest**](UpdateProfileRequest.md)|  | 

### Return type

[**AuthProfileGet200Response**](AuthProfileGet200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authRefreshTokenPost**
> AuthRefreshTokenPost200Response authRefreshTokenPost(refreshTokenRequest)

Refresh access token

Get new access token using refresh token

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getAuthenticationApi();
final RefreshTokenRequest refreshTokenRequest = ; // RefreshTokenRequest | 

try {
    final response = api.authRefreshTokenPost(refreshTokenRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthenticationApi->authRefreshTokenPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refreshTokenRequest** | [**RefreshTokenRequest**](RefreshTokenRequest.md)|  | 

### Return type

[**AuthRefreshTokenPost200Response**](AuthRefreshTokenPost200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authRegisterPost**
> AuthRegisterPost201Response authRegisterPost(registerRequest)

Register a new user

Create a new user account with email and password

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getAuthenticationApi();
final RegisterRequest registerRequest = ; // RegisterRequest | 

try {
    final response = api.authRegisterPost(registerRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthenticationApi->authRegisterPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **registerRequest** | [**RegisterRequest**](RegisterRequest.md)|  | 

### Return type

[**AuthRegisterPost201Response**](AuthRegisterPost201Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authResetPasswordPost**
> AuthResetPasswordPost200Response authResetPasswordPost(resetPasswordRequest)

Request password reset

Send password reset email to user

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getAuthenticationApi();
final ResetPasswordRequest resetPasswordRequest = ; // ResetPasswordRequest | 

try {
    final response = api.authResetPasswordPost(resetPasswordRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthenticationApi->authResetPasswordPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **resetPasswordRequest** | [**ResetPasswordRequest**](ResetPasswordRequest.md)|  | 

### Return type

[**AuthResetPasswordPost200Response**](AuthResetPasswordPost200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authVerifyTokenGet**
> AuthVerifyTokenGet200Response authVerifyTokenGet()

Verify token validity

Verify if the provided token is valid and return user information

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getAuthenticationApi();

try {
    final response = api.authVerifyTokenGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthenticationApi->authVerifyTokenGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AuthVerifyTokenGet200Response**](AuthVerifyTokenGet200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

