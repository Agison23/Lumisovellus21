import 'package:lumisovellus_api/lumisovellus_api.dart';
import '../services/snow_types_service.dart';

class SnowTypesRepository {
  final SnowTypesService service;

  SnowTypesRepository(this.service);

  Future<List<SnowType>> getSnowTypes() {
    return service.fetchSnowTypes();
  }
}
