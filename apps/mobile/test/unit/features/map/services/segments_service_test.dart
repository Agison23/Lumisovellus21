import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import 'package:lumisovellus/core/network/api_client.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';
import 'package:lumisovellus/features/map/data/services/segments_service.dart';

@GenerateNiceMocks([MockSpec<ApiClient>(), MockSpec<SegmentsApi>()])
import 'segments_service_test.mocks.dart';

Segment _segment(String id) => Segment(
  id: id,
  name: 'Seg $id',
  terrain: 'Terrain',
  avalancheDanger: false,
  isLowerSegment: null,
  points: const [],
  guideUpdate: null,
  userReviews: const [],
);

HealthGet200ResponseMeta _meta() =>
    HealthGet200ResponseMeta(timestamp: DateTime(2024, 1, 1), message: 'ok');

void main() {
  late MockApiClient mockApiClient;
  late MockSegmentsApi mockSegmentsApi;
  late SegmentsService service;

  setUp(() {
    mockApiClient = MockApiClient();
    mockSegmentsApi = MockSegmentsApi();

    when(mockApiClient.segments).thenReturn(mockSegmentsApi);

    service = SegmentsService(mockApiClient);
  });

  test('fetchSegments returns list of segments when API succeeds', () async {
    const bbox = '24.0,68.0,24.5,68.5';
    const search = 'pallas';
    final updatedSince = DateTime(2024, 1, 1);

    final segments = [_segment('s1'), _segment('s2')];

    final body = ApiV1SegmentsGet200Response(
      success: true,
      data: segments,
      meta: _meta(),
    );

    when(
      mockSegmentsApi.apiV1SegmentsGet(
        bbox: bbox,
        search: search,
        updatedSince: updatedSince,
      ),
    ).thenAnswer(
      (_) async => Response<ApiV1SegmentsGet200Response>(
        data: body,
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      ),
    );

    final result = await service.fetchSegments(
      bbox: bbox,
      search: search,
      updatedSince: updatedSince,
    );

    expect(result, segments);
    verify(
      mockSegmentsApi.apiV1SegmentsGet(
        bbox: bbox,
        search: search,
        updatedSince: updatedSince,
      ),
    ).called(1);
  });

  test('fetchSegments throws when body is null', () async {
    when(
      mockSegmentsApi.apiV1SegmentsGet(
        bbox: null,
        search: null,
        updatedSince: null,
      ),
    ).thenAnswer(
      (_) async => Response<ApiV1SegmentsGet200Response>(
        data: null,
        statusCode: 500,
        requestOptions: RequestOptions(path: ''),
      ),
    );

    expect(() => service.fetchSegments(), throwsA(isA<Exception>()));
  });

  test('fetchSegments throws when success is false', () async {
    final body = ApiV1SegmentsGet200Response(
      success: false,
      data: [_segment('s1')],
      meta: _meta(),
    );

    when(
      mockSegmentsApi.apiV1SegmentsGet(
        bbox: null,
        search: null,
        updatedSince: null,
      ),
    ).thenAnswer(
      (_) async => Response<ApiV1SegmentsGet200Response>(
        data: body,
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      ),
    );

    expect(() => service.fetchSegments(), throwsA(isA<Exception>()));
  });
}
