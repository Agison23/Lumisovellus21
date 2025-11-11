# lumisovellus_api.model.SegmentUpdate

## Load the model package
```dart
import 'package:lumisovellus_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | Update ID | 
**segment** | **String** | Segment ID | 
**time** | [**DateTime**](DateTime.md) | Update timestamp | 
**description** | **String** |  | 
**weather** | **String** |  | 
**temperature** | **num** |  | 
**windSpeed** | **num** |  | 
**visibility** | **num** |  | 
**status** | **String** | Update status | 
**priority** | **int** | Update priority | 
**creator** | [**Creator**](Creator.md) | Update creator information | 
**segmentName** | **String** | Segment name | 
**snowConditions** | [**List&lt;SnowCondition&gt;**](SnowCondition.md) | Snow conditions for this update | 
**reviewReferences** | [**List&lt;ReviewReference&gt;**](ReviewReference.md) | Review references associated with this update | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


