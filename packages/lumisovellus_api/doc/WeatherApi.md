# lumisovellus_api.api.WeatherApi

## Load the API package
```dart
import 'package:lumisovellus_api/api.dart';
```

All URIs are relative to *http://localhost:3001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**weatherAverageGet**](WeatherApi.md#weatheraverageget) | **GET** /weather/average | Average weather metric
[**weatherChangeGet**](WeatherApi.md#weatherchangeget) | **GET** /weather/change | Snow depth change
[**weatherFilterDaysGet**](WeatherApi.md#weatherfilterdaysget) | **GET** /weather/filterDays | Filter days with average temperature above threshold
[**weatherMaximumGet**](WeatherApi.md#weathermaximumget) | **GET** /weather/maximum | Maximum weather metric
[**weatherMinimumGet**](WeatherApi.md#weatherminimumget) | **GET** /weather/minimum | Minimum temperature


# **weatherAverageGet**
> WeatherAverageGet200Response weatherAverageGet(item, days)

Average weather metric

Returns the average for supported weather items within the requested period.

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getWeatherApi();
final String item = windSpeed; // String | Weather item to average
final int days = 3; // int | Number of days to include

try {
    final response = api.weatherAverageGet(item, days);
    print(response);
} catch on DioException (e) {
    print('Exception when calling WeatherApi->weatherAverageGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **item** | **String**| Weather item to average | 
 **days** | **int**| Number of days to include | [optional] [default to 3]

### Return type

[**WeatherAverageGet200Response**](WeatherAverageGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **weatherChangeGet**
> WeatherAverageGet200Response weatherChangeGet(item, days)

Snow depth change

Returns the change in snow depth between the start and end of the requested period.

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getWeatherApi();
final String item = snowDepth; // String | Weather item to calculate change for
final int days = 7; // int | Number of days to look back from now

try {
    final response = api.weatherChangeGet(item, days);
    print(response);
} catch on DioException (e) {
    print('Exception when calling WeatherApi->weatherChangeGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **item** | **String**| Weather item to calculate change for | 
 **days** | **int**| Number of days to look back from now | [optional] [default to 7]

### Return type

[**WeatherAverageGet200Response**](WeatherAverageGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **weatherFilterDaysGet**
> WeatherFilterDaysGet200Response weatherFilterDaysGet(item, threshold, days)

Filter days with average temperature above threshold

Returns the dates within the requested period where the daily average temperature exceeded the threshold.

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getWeatherApi();
final String item = temperature; // String | Weather item used for filtering
final num threshold = 0; // num | Threshold to compare against
final int days = 3; // int | Number of days to include

try {
    final response = api.weatherFilterDaysGet(item, threshold, days);
    print(response);
} catch on DioException (e) {
    print('Exception when calling WeatherApi->weatherFilterDaysGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **item** | **String**| Weather item used for filtering | 
 **threshold** | **num**| Threshold to compare against | 
 **days** | **int**| Number of days to include | [optional] [default to 3]

### Return type

[**WeatherFilterDaysGet200Response**](WeatherFilterDaysGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **weatherMaximumGet**
> WeatherAverageGet200Response weatherMaximumGet(item, days)

Maximum weather metric

Returns the maximum temperature or wind speed within the requested period.

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getWeatherApi();
final String item = windSpeed; // String | Weather item to get maximum for
final int days = 3; // int | Number of days to include

try {
    final response = api.weatherMaximumGet(item, days);
    print(response);
} catch on DioException (e) {
    print('Exception when calling WeatherApi->weatherMaximumGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **item** | **String**| Weather item to get maximum for | 
 **days** | **int**| Number of days to include | [optional] [default to 3]

### Return type

[**WeatherAverageGet200Response**](WeatherAverageGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **weatherMinimumGet**
> WeatherAverageGet200Response weatherMinimumGet(item, days)

Minimum temperature

Returns the minimum temperature within the requested period.

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getWeatherApi();
final String item = temperature; // String | Weather item to get minimum for
final int days = 3; // int | Number of days to include

try {
    final response = api.weatherMinimumGet(item, days);
    print(response);
} catch on DioException (e) {
    print('Exception when calling WeatherApi->weatherMinimumGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **item** | **String**| Weather item to get minimum for | 
 **days** | **int**| Number of days to include | [optional] [default to 3]

### Return type

[**WeatherAverageGet200Response**](WeatherAverageGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

