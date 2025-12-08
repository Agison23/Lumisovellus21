import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:lumisovellus_api/lumisovellus_api.dart';
import 'package:lumisovellus/features/map/data/services/segments_service.dart';
import 'package:lumisovellus/features/map/data/repositories/segments_repository.dart';

@GenerateNiceMocks([MockSpec<SegmentsService>()])
import 'segments_repository_test.mocks.dart';

Segment _seg(String id) => Segment(
  id: id,
  name: 'Seg $id',
  terrain: 'Terrain',
  avalancheDanger: false,
  isLowerSegment: null,
  points: const [],
  guideUpdate: null,
  userReviews: const [],
);

void main() {
  late MockSegmentsService mockService;
  late SegmentsRepository repo;

  setUp(() {
    mockService = MockSegmentsService();
    repo = SegmentsRepository(mockService);
  });

  test('getAreas delegates to service and returns result', () async {
    final segments = [_seg('s1'), _seg('s2')];

    when(mockService.fetchSegments()).thenAnswer((_) async => segments);

    final result = await repo.getAreas();

    expect(result, segments);
    verify(mockService.fetchSegments()).called(1);
  });

  test('getAreas propagates exceptions', () async {
    when(mockService.fetchSegments()).thenThrow(Exception('network'));

    expect(() => repo.getAreas(), throwsA(isA<Exception>()));
  });
}
