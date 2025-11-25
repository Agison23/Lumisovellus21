import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import 'package:lumisovellus/core/network/api_client.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';
import 'package:lumisovellus/features/map/data/services/reviews_service.dart';

@GenerateNiceMocks([
  MockSpec<ApiClient>(),
  MockSpec<
    ReviewsApi
  >(),
])
import 'reviews_service_test.mocks.dart';

void main() {
  late MockApiClient mockApiClient;
  late MockReviewsApi mockReviewsApi;
  late ReviewsService service;

  setUp(() {
    mockApiClient = MockApiClient();
    mockReviewsApi = MockReviewsApi();

    when(mockApiClient.reviews).thenReturn(mockReviewsApi);

    service = ReviewsService(mockApiClient);
  });

  test('createReview throws when body is null', () async {
    const segmentId = 'seg-1';
    final request = ApiV1SegmentsIdReviewsPostRequest(
      snowType: 'uusi_lumi',
      hazards: const [],
    );

    when(
      mockReviewsApi.apiV1SegmentsIdReviewsPost(
        id: segmentId,
        apiV1SegmentsIdReviewsPostRequest: request,
      ),
    ).thenAnswer(
      (_) async => Response<ApiV1SegmentsIdReviewsPost201Response>(
        data: null,
        statusCode: 500,
        requestOptions: RequestOptions(path: ''),
      ),
    );

    expect(
      () => service.createReview(segmentId: segmentId, review: request),
      throwsA(isA<Exception>()),
    );
  });

  test('createReview throws when success is false', () async {
    const segmentId = 'seg-1';
    final request = ApiV1SegmentsIdReviewsPostRequest(
      snowType: 'uusi_lumi',
      hazards: const [],
    );

    final reviewData = ReviewResponse(
      id: 'rev-1',
      time: DateTime(2024, 1, 1),
      segment: segmentId,
      snowType: 'uusi_lumi',
      secondarySnowType: null,
      hazards: const [],
      comment: 'Nice snow',
    );

    final meta = HealthGet200ResponseMeta(
      timestamp: DateTime(2024, 1, 1),
      message: 'test meta',
    );

    final body = ApiV1SegmentsIdReviewsPost201Response(
      success: false,
      data: reviewData,
      meta: meta,
    );

    when(
      mockReviewsApi.apiV1SegmentsIdReviewsPost(
        id: segmentId,
        apiV1SegmentsIdReviewsPostRequest: request,
      ),
    ).thenAnswer(
      (_) async => Response<ApiV1SegmentsIdReviewsPost201Response>(
        data: body,
        statusCode: 201,
        requestOptions: RequestOptions(path: ''),
      ),
    );

    expect(
      () => service.createReview(segmentId: segmentId, review: request),
      throwsA(isA<Exception>()),
    );
  });

  test('createReview calls underlying API with correct arguments', () async {
    const segmentId = 'seg-1';
    final request = ApiV1SegmentsIdReviewsPostRequest(
      snowType: 'uusi_lumi',
      hazards: const [],
    );

    final reviewData = ReviewResponse(
      id: 'rev-1',
      time: DateTime(2024, 1, 1),
      segment: segmentId,
      snowType: 'uusi_lumi',
      secondarySnowType: null,
      hazards: const [],
      comment: 'Nice snow',
    );

    final meta = HealthGet200ResponseMeta(
      timestamp: DateTime(2024, 1, 1),
      message: 'test meta',
    );

    final body = ApiV1SegmentsIdReviewsPost201Response(
      success: true,
      data: reviewData,
      meta: meta,
    );

    when(
      mockReviewsApi.apiV1SegmentsIdReviewsPost(
        id: segmentId,
        apiV1SegmentsIdReviewsPostRequest: request,
      ),
    ).thenAnswer(
      (_) async => Response<ApiV1SegmentsIdReviewsPost201Response>(
        data: body,
        statusCode: 201,
        requestOptions: RequestOptions(path: ''),
      ),
    );

    await service.createReview(segmentId: segmentId, review: request);

    verify(
      mockReviewsApi.apiV1SegmentsIdReviewsPost(
        id: segmentId,
        apiV1SegmentsIdReviewsPostRequest: request,
      ),
    ).called(1);
  });
}
