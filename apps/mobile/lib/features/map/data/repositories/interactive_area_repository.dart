import '../models/interactive_area.dart';
import '../services/interactive_area_service.dart';

class InteractiveAreaRepository {
  final InteractiveAreaService service;
  InteractiveAreaRepository(this.service);
  Future<List<InteractiveAreaFeature>> getAreas({bool alt = true}) =>
      service.fetchAreas(alt: alt);
}
