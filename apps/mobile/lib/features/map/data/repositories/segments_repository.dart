import 'package:lumisovellus_api/lumisovellus_api.dart';
import '../services/segments_service.dart';

class SegmentsRepository {
  final SegmentsService service;

  SegmentsRepository(this.service);

  Future<List<Segment>> getAreas() {
    return service.fetchSegments();
  }
}
