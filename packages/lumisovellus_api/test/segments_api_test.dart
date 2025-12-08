import 'package:test/test.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';


/// tests for SegmentsApi
void main() {
  final instance = LumisovellusApi().getSegmentsApi();

  group(SegmentsApi, () {
    // Get all segments
    //
    // Retrieve all ski segments with their coordinates and terrain information. Supports filtering by bounding box, search, and updatedSince.
    //
    //Future<ApiV1SegmentsGet200Response> apiV1SegmentsGet({ String observationDays, String bbox, String minLat, String minLng, String maxLat, String maxLng, String search, DateTime updatedSince }) async
    test('test apiV1SegmentsGet', () async {
      // TODO
    });

    // Create or update a guide update for a segment (Admin only)
    //
    // Creates a new guide update or updates the existing one for a segment. Only admins can create guide updates.
    //
    //Future<ApiV1SegmentsIdGuideUpdatePost200Response> apiV1SegmentsIdGuideUpdatePost(String id, GuideUpdateRequest guideUpdateRequest) async
    test('test apiV1SegmentsIdGuideUpdatePost', () async {
      // TODO
    });

  });
}
