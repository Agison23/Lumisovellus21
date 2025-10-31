import 'dart:async';
import '../models/snow_type.dart';
import 'snow_type_service.dart';
import 'mock_data.dart';

class MockSnowTypeService implements SnowTypeService {
  @override
  Future<List<SnowType>> fetchSnowTypes() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return mockSnowData.map((m) => SnowType.fromMap(m)).toList();
    }
}
