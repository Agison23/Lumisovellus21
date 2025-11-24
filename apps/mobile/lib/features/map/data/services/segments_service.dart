import 'package:lumisovellus/core/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';

class SegmentsService {
  final ApiClient api;

  SegmentsService(this.api);

  Future<List<Segment>> fetchSegments({
    String? bbox,
    String? search,
    DateTime? updatedSince,
  }) async {
    final Response<ApiV1SegmentsGet200Response> res = await api.segments
        .apiV1SegmentsGet(
          bbox: bbox,
          search: search,
          updatedSince: updatedSince,
        );

    final body = res.data;
    if (body == null || body.success != true) {
      throw Exception('Failed to load segments');
    }

    return body.data;
  }
}
