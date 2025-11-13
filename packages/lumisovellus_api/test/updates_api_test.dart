import 'package:test/test.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';


/// tests for UpdatesApi
void main() {
  final instance = LumisovellusApi().getUpdatesApi();

  group(UpdatesApi, () {
    // Get updates for segments
    //
    // Get updates filtered by updatedSince or time range; include review details.
    //
    //Future<ApiV1SegmentsIdUpdatesGet200Response> apiV1UpdatesGet({ String days, String segmentId, DateTime updatedSince, DateTime from, DateTime to }) async
    test('test apiV1UpdatesGet', () async {
      // TODO
    });

  });
}
