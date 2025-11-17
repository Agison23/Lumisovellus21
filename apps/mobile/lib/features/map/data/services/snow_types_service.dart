import 'package:lumisovellus/core/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';

class SnowTypesService {
  final ApiClient api;

  SnowTypesService(this.api);

  Future<List<SnowType>> fetchSnowTypes({
    String? bbox,
    String? search,
    DateTime? updatedSince,
  }) async {
    final Response<ApiV1SnowTypesGet200Response> res = await api.snowTypes
        .apiV1SnowTypesGet();

    final body = res.data;
    if (body == null || body.success != true) {
      throw Exception('Failed to load snow types');
    }

    return body.data;
  }
}
