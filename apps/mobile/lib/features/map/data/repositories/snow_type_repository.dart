import '../models/snow_type.dart';
import '../services/snow_type_service.dart';

class SnowTypeRepository {
  final SnowTypeService service;
  SnowTypeRepository(this.service);
  Future<List<SnowType>> getSnowTypes() => service.fetchSnowTypes();
}
