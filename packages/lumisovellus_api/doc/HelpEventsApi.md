# lumisovellus_api.api.HelpEventsApi

## Load the API package
```dart
import 'package:lumisovellus_api/api.dart';
```

All URIs are relative to *http://localhost:3001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**helpEventsEventIdAcceptanceDelete**](HelpEventsApi.md#helpeventseventidacceptancedelete) | **DELETE** /help/events/{eventId}/acceptance | Withdraw from help event
[**helpEventsEventIdAcceptancePost**](HelpEventsApi.md#helpeventseventidacceptancepost) | **POST** /help/events/{eventId}/acceptance | Accept help event
[**helpEventsEventIdPatch**](HelpEventsApi.md#helpeventseventidpatch) | **PATCH** /help/events/{eventId} | Update help event status
[**helpEventsEventIdStreamGet**](HelpEventsApi.md#helpeventseventidstreamget) | **GET** /help/events/{eventId}/stream | Stream help event updates
[**helpEventsEventIdViewGet**](HelpEventsApi.md#helpeventseventidviewget) | **GET** /help/events/{eventId}/view | Get help event view
[**helpEventsNearbyGet**](HelpEventsApi.md#helpeventsnearbyget) | **GET** /help/events/nearby | List nearby help events
[**helpEventsPost**](HelpEventsApi.md#helpeventspost) | **POST** /help/events | Create a new help event


# **helpEventsEventIdAcceptanceDelete**
> HelpEventsEventIdAcceptancePost200Response helpEventsEventIdAcceptanceDelete(eventId)

Withdraw from help event

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getHelpEventsApi();
final String eventId = event_123; // String | Help event identifier

try {
    final response = api.helpEventsEventIdAcceptanceDelete(eventId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling HelpEventsApi->helpEventsEventIdAcceptanceDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **eventId** | **String**| Help event identifier | 

### Return type

[**HelpEventsEventIdAcceptancePost200Response**](HelpEventsEventIdAcceptancePost200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **helpEventsEventIdAcceptancePost**
> HelpEventsEventIdAcceptancePost200Response helpEventsEventIdAcceptancePost(eventId, helpEventAcceptance)

Accept help event

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getHelpEventsApi();
final String eventId = event_123; // String | Help event identifier
final HelpEventAcceptance helpEventAcceptance = ; // HelpEventAcceptance | 

try {
    final response = api.helpEventsEventIdAcceptancePost(eventId, helpEventAcceptance);
    print(response);
} catch on DioException (e) {
    print('Exception when calling HelpEventsApi->helpEventsEventIdAcceptancePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **eventId** | **String**| Help event identifier | 
 **helpEventAcceptance** | [**HelpEventAcceptance**](HelpEventAcceptance.md)|  | 

### Return type

[**HelpEventsEventIdAcceptancePost200Response**](HelpEventsEventIdAcceptancePost200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **helpEventsEventIdPatch**
> HelpEventsPost201Response helpEventsEventIdPatch(eventId, helpEventStatusUpdate)

Update help event status

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getHelpEventsApi();
final String eventId = event_123; // String | Help event identifier
final HelpEventStatusUpdate helpEventStatusUpdate = ; // HelpEventStatusUpdate | 

try {
    final response = api.helpEventsEventIdPatch(eventId, helpEventStatusUpdate);
    print(response);
} catch on DioException (e) {
    print('Exception when calling HelpEventsApi->helpEventsEventIdPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **eventId** | **String**| Help event identifier | 
 **helpEventStatusUpdate** | [**HelpEventStatusUpdate**](HelpEventStatusUpdate.md)|  | 

### Return type

[**HelpEventsPost201Response**](HelpEventsPost201Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **helpEventsEventIdStreamGet**
> helpEventsEventIdStreamGet(eventId)

Stream help event updates

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getHelpEventsApi();
final String eventId = event_123; // String | Help event identifier

try {
    api.helpEventsEventIdStreamGet(eventId);
} catch on DioException (e) {
    print('Exception when calling HelpEventsApi->helpEventsEventIdStreamGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **eventId** | **String**| Help event identifier | 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **helpEventsEventIdViewGet**
> HelpEventsEventIdViewGet200Response helpEventsEventIdViewGet(eventId)

Get help event view

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getHelpEventsApi();
final String eventId = event_123; // String | Help event identifier

try {
    final response = api.helpEventsEventIdViewGet(eventId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling HelpEventsApi->helpEventsEventIdViewGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **eventId** | **String**| Help event identifier | 

### Return type

[**HelpEventsEventIdViewGet200Response**](HelpEventsEventIdViewGet200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **helpEventsNearbyGet**
> HelpEventsNearbyGet200Response helpEventsNearbyGet(lat, lng, accuracy)

List nearby help events

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getHelpEventsApi();
final num lat = 65.0121; // num | Latitude of requesting user
final num lng = 25.4651; // num | Longitude of requesting user
final int accuracy = 3000; // int | Search radius in meters

try {
    final response = api.helpEventsNearbyGet(lat, lng, accuracy);
    print(response);
} catch on DioException (e) {
    print('Exception when calling HelpEventsApi->helpEventsNearbyGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lat** | **num**| Latitude of requesting user | 
 **lng** | **num**| Longitude of requesting user | 
 **accuracy** | **int**| Search radius in meters | [optional] 

### Return type

[**HelpEventsNearbyGet200Response**](HelpEventsNearbyGet200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **helpEventsPost**
> HelpEventsPost201Response helpEventsPost(helpEventCreate)

Create a new help event

### Example
```dart
import 'package:lumisovellus_api/api.dart';

final api = LumisovellusApi().getHelpEventsApi();
final HelpEventCreate helpEventCreate = ; // HelpEventCreate | 

try {
    final response = api.helpEventsPost(helpEventCreate);
    print(response);
} catch on DioException (e) {
    print('Exception when calling HelpEventsApi->helpEventsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **helpEventCreate** | [**HelpEventCreate**](HelpEventCreate.md)|  | 

### Return type

[**HelpEventsPost201Response**](HelpEventsPost201Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

