import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';
import 'package:lumisovellus/features/map/data/services/reviews_service.dart';
import 'package:lumisovellus/features/map/data/repositories/reviews_repository.dart';

@GenerateNiceMocks([MockSpec<ReviewsService>()])
import 'reviews_repository_test.mocks.dart';

void main() {
  late MockReviewsService mockService;
  late ReviewsRepository repository;

  setUp(() {
    mockService = MockReviewsService();
    repository = ReviewsRepository(mockService);
  });

  test('createReview delegates to service and returns result', () async {
    const segmentId = 'seg-1';
    final request = ApiV1SegmentsIdReviewsPostRequest(
      snowType: 'uusi_lumi',
      hazards: const [],
    );

    final response = ReviewResponse(
      id: 'rev-1',
      time: DateTime(2024, 1, 1),
      segment: segmentId,
      snowType: 'uusi_lumi',
      secondarySnowType: null,
      hazards: const [],
      comment: 'Nice snow',
    );

    when(
      mockService.createReview(segmentId: segmentId, review: request),
    ).thenAnswer((_) async => response);

    final result = await repository.createReview(
      segmentId: segmentId,
      review: request,
    );

    expect(result, same(response));

    verify(
      mockService.createReview(segmentId: segmentId, review: request),
    ).called(1);
  });

  test('createReview propagates exceptions from service', () async {
    const segmentId = 'seg-err';
    final request = ApiV1SegmentsIdReviewsPostRequest(
      snowType: 'uusi_lumi',
      hazards: const [],
    );

    when(
      mockService.createReview(segmentId: segmentId, review: request),
    ).thenThrow(Exception('network'));

    expect(
      () => repository.createReview(segmentId: segmentId, review: request),
      throwsA(isA<Exception>()),
    );
  });
}
