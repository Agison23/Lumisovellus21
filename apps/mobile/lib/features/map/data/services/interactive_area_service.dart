import '../models/interactive_area.dart';

abstract class InteractiveAreaService {
  Future<List<InteractiveAreaFeature>> fetchAreas({bool alt});
}
