# lumisovellus_api.model.WeatherFilterDaysResponse

## Load the model package
```dart
import 'package:lumisovellus_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**item** | **String** | Weather item used for filtering | 
**threshold** | **num** | Threshold for the average temperature | 
**days** | **int** | Number of days inspected | 
**period** | [**WeatherPeriod**](WeatherPeriod.md) |  | 
**location** | [**WeatherLocation**](WeatherLocation.md) |  | 
**matches** | [**List&lt;WeatherFilterDaysResponseMatchesInner&gt;**](WeatherFilterDaysResponseMatchesInner.md) | Dates matching the filter | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


