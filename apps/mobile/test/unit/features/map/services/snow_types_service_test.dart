import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import 'package:lumisovellus/core/network/api_client.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';
import 'package:lumisovellus/features/map/data/services/snow_types_service.dart';

@GenerateNiceMocks([MockSpec<ApiClient>(), MockSpec<SnowTypesApi>()])
import 'snow_types_service_test.mocks.dart';

SnowType _snowType(String id) => SnowType(
  id: id,
  identifier: id,
  name: 'Snow $id',
  colour: '#000000',
  skiability: 3,
  primarySnowTypeId: null,
  explanation: 'desc',
);

HealthGet200ResponseMeta _meta() =>
    HealthGet200ResponseMeta(timestamp: DateTime(2024, 1, 1), message: 'ok');

void main() {
  late MockApiClient mockApiClient;
  late MockSnowTypesApi mockSnowTypesApi;
  late SnowTypesService service;

  setUp(() {
    mockApiClient = MockApiClient();
    mockSnowTypesApi = MockSnowTypesApi();

    when(mockApiClient.snowTypes).thenReturn(mockSnowTypesApi);

    service = SnowTypesService(mockApiClient);
  });

  test('fetchSnowTypes returns list of snow types when API succeeds', () async {
    final snowTypes = [_snowType('st1'), _snowType('st2')];

    final body = ApiV1SnowTypesGet200Response(
      success: true,
      data: snowTypes,
      meta: _meta(),
    );

    when(mockSnowTypesApi.apiV1SnowTypesGet()).thenAnswer(
      (_) async => Response<ApiV1SnowTypesGet200Response>(
        data: body,
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      ),
    );

    final result = await service.fetchSnowTypes();

    expect(result, snowTypes);
    verify(mockSnowTypesApi.apiV1SnowTypesGet()).called(1);
  });

  test('fetchSnowTypes throws when body is null', () async {
    when(mockSnowTypesApi.apiV1SnowTypesGet()).thenAnswer(
      (_) async => Response<ApiV1SnowTypesGet200Response>(
        data: null,
        statusCode: 500,
        requestOptions: RequestOptions(path: ''),
      ),
    );

    expect(() => service.fetchSnowTypes(), throwsA(isA<Exception>()));
  });

  test('fetchSnowTypes throws when success is false', () async {
    final body = ApiV1SnowTypesGet200Response(
      success: false,
      data: [_snowType('st1')],
      meta: _meta(),
    );

    when(mockSnowTypesApi.apiV1SnowTypesGet()).thenAnswer(
      (_) async => Response<ApiV1SnowTypesGet200Response>(
        data: body,
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      ),
    );

    expect(() => service.fetchSnowTypes(), throwsA(isA<Exception>()));
  });
}
