import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:lumisovellus_api/lumisovellus_api.dart';
import 'package:lumisovellus/features/map/data/services/snow_types_service.dart';
import 'package:lumisovellus/features/map/data/repositories/snow_types_repository.dart';

@GenerateNiceMocks([MockSpec<SnowTypesService>()])
import 'snow_types_repository_test.mocks.dart';

SnowType _snow(String id) => SnowType(
  id: id,
  identifier: id,
  name: 'Snow $id',
  colour: '#000000',
  skiability: 3,
  primarySnowTypeId: null,
  explanation: 'desc',
);

void main() {
  late MockSnowTypesService mockService;
  late SnowTypesRepository repo;

  setUp(() {
    mockService = MockSnowTypesService();
    repo = SnowTypesRepository(mockService);
  });

  test('getSnowTypes delegates to service and returns result', () async {
    final snowTypes = [_snow('st1'), _snow('st2')];

    when(mockService.fetchSnowTypes()).thenAnswer((_) async => snowTypes);

    final result = await repo.getSnowTypes();

    expect(result, snowTypes);
    verify(mockService.fetchSnowTypes()).called(1);
  });

  test('getSnowTypes propagates exceptions', () async {
    when(mockService.fetchSnowTypes()).thenThrow(Exception('network'));

    expect(() => repo.getSnowTypes(), throwsA(isA<Exception>()));
  });
}
