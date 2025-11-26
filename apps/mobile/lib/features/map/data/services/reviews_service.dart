import 'package:dio/dio.dart';
import 'package:lumisovellus/core/network/api_client.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';

class ReviewsService {
  final ApiClient api;

  ReviewsService(this.api);

  Future<ReviewResponse> createReview({
    required String segmentId,
    required ApiV1SegmentsIdReviewsPostRequest review,
  }) async {
    final Response<ApiV1SegmentsIdReviewsPost201Response> res = await api
        .reviews
        .apiV1SegmentsIdReviewsPost(
          id: segmentId,
          apiV1SegmentsIdReviewsPostRequest: review,
        );

    final body = res.data;
    if (body == null || body.success != true) {
      throw Exception('Failed to create review');
    }

    return body.data;
  }
}
