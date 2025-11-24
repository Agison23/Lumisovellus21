# lumisovellus_api.model.GuideUpdateRequest

## Load the model package
```dart
import 'package:lumisovellus_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**description** | **String** | Description of the guide update | [optional] 
**primarySnowTypeIds** | **List&lt;String&gt;** | Array of primary snow type IDs (max 2) | [optional] [default to []]
**secondarySnowTypeIds** | **List&lt;String&gt;** | Array of secondary snow type IDs (max 2) | [optional] [default to []]
**hazards** | [**List&lt;Hazard&gt;**](Hazard.md) | Array of hazards found on the trail (e.g., [\"stones\", \"branches\"]) | [optional] [default to []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


