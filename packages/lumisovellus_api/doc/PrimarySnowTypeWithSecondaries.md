# lumisovellus_api.model.PrimarySnowTypeWithSecondaries

## Load the model package
```dart
import 'package:lumisovellus_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | Snow type ID (UUID) | 
**name** | **String** | Snow type name | 
**colour** | **String** | Snow type colour in hex format | 
**skiability** | **int** | Skiability rating (1-5), nullable | [optional] 
**primarySnowTypeId** | **String** | Primary snow type ID. NULL for primary snow types, UUID for secondary snow types | [optional] 
**explanation** | **String** | Explanation of the snow type | [optional] 
**secondarySnowTypes** | [**List&lt;SnowType&gt;**](SnowType.md) | Secondary snow types for this primary type | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


