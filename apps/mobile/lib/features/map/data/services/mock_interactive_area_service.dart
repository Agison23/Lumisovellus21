import 'dart:async';
import '../models/interactive_area.dart';
import 'interactive_area_service.dart';
import 'mock_data.dart';

class MockInteractiveAreaService implements InteractiveAreaService {
  @override
  Future<List<InteractiveAreaFeature>> fetchAreas({bool alt = false}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final raw = alt ? mapAreas2 : mapAreas;
    return raw.map((m) => InteractiveAreaFeature.fromMap(m)).toList();
  }
}
