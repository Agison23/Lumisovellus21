# lumisovellus_api.api.WeatherApi

## Load the API package
```dart
import 'package:lumisovellus_api/api.dart';
```

All URIs are relative to *http://localhost:3001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**weatherGet**](WeatherApi.md#weatherget) | **GET** /weather | Get latest weather data
[**weatherHistoryGet**](WeatherApi.md#weatherhistoryget) | **GET** /weather/history | Get weather history
[**weatherUpdatePost**](WeatherApi.md#weatherupdatepost) | **POST** /weather/update | Manually trigger weather update


# **weatherGet**
> ApiV1SnowTypesPost201Response weatherGet()

Get latest weather data

Returns the most recent weather data from the FMI API

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getWeatherApi();

try {
    final response = api.weatherGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling WeatherApi->weatherGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ApiV1SnowTypesPost201Response**](ApiV1SnowTypesPost201Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **weatherHistoryGet**
> ApiV1SnowTypesGet200Response weatherHistoryGet(limit)

Get weather history

Returns historical weather data

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getWeatherApi();
final String limit = 100; // String | Maximum number of records to return

try {
    final response = api.weatherHistoryGet(limit);
    print(response);
} catch on DioException (e) {
    print('Exception when calling WeatherApi->weatherHistoryGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **String**| Maximum number of records to return | [optional] 

### Return type

[**ApiV1SnowTypesGet200Response**](ApiV1SnowTypesGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **weatherUpdatePost**
> ApiV1SnowTypesPost201Response weatherUpdatePost()

Manually trigger weather update

Fetches new weather data from FMI API and saves it to database

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getWeatherApi();

try {
    final response = api.weatherUpdatePost();
    print(response);
} catch on DioException (e) {
    print('Exception when calling WeatherApi->weatherUpdatePost: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ApiV1SnowTypesPost201Response**](ApiV1SnowTypesPost201Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

