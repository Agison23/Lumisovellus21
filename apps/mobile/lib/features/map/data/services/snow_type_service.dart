import '../models/snow_type.dart';

abstract class SnowTypeService {
  Future<List<SnowType>> fetchSnowTypes();
}
