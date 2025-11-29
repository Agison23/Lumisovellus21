import 'package:lumisovellus_api/lumisovellus_api.dart';
import '../services/reviews_service.dart';

class ReviewsRepository {
  final ReviewsService service;

  ReviewsRepository(this.service);

  Future<ReviewResponse> createReview({
    required String segmentId,
    required ApiV1SegmentsIdReviewsPostRequest review,
  }) {
    return service.createReview(segmentId: segmentId, review: review);
  }
}
