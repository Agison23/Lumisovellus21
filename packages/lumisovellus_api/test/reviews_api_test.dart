import 'package:test/test.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';


/// tests for ReviewsApi
void main() {
  final instance = LumisovellusApi().getReviewsApi();

  group(ReviewsApi, () {
    // Get observations for all segments
    //
    // Retrieve observations (reviews and guide updates) for all segments from the last N days, grouped by segment. Supports pagination of segments.
    //
    //Future<ApiV1ObservationsGet200Response> apiV1ObservationsGet({ String days, String limit, String page, String pageSize }) async
    test('test apiV1ObservationsGet', () async {
      // TODO
    });

    // Get observations for a specific segment
    //
    // Retrieve guide updates and user reviews for a specific segment within the requested time window.
    //
    //Future<ApiV1SegmentsIdObservationsGet200Response> apiV1SegmentsIdObservationsGet(String id, { String days, String limit }) async
    test('test apiV1SegmentsIdObservationsGet', () async {
      // TODO
    });

    // Create a review for a segment
    //
    // Submit a snow condition review for a specific segment
    //
    //Future<ApiV1SnowTypesPost201Response> apiV1SegmentsIdReviewsPost(String id, ApiV1SegmentsIdReviewsPostRequest apiV1SegmentsIdReviewsPostRequest) async
    test('test apiV1SegmentsIdReviewsPost', () async {
      // TODO
    });

  });
}
