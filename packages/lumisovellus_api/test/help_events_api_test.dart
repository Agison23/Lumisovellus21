import 'package:test/test.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';


/// tests for HelpEventsApi
void main() {
  final instance = LumisovellusApi().getHelpEventsApi();

  group(HelpEventsApi, () {
    // Withdraw from help event
    //
    //Future<HelpEventsEventIdAcceptancePost200Response> helpEventsEventIdAcceptanceDelete(String eventId) async
    test('test helpEventsEventIdAcceptanceDelete', () async {
      // TODO
    });

    // Accept help event
    //
    //Future<HelpEventsEventIdAcceptancePost200Response> helpEventsEventIdAcceptancePost(String eventId, HelpEventAcceptance helpEventAcceptance) async
    test('test helpEventsEventIdAcceptancePost', () async {
      // TODO
    });

    // Update help event status
    //
    //Future<HelpEventsPost201Response> helpEventsEventIdPatch(String eventId, HelpEventStatusUpdate helpEventStatusUpdate) async
    test('test helpEventsEventIdPatch', () async {
      // TODO
    });

    // Stream help event updates
    //
    //Future helpEventsEventIdStreamGet(String eventId) async
    test('test helpEventsEventIdStreamGet', () async {
      // TODO
    });

    // Get help event view
    //
    //Future<HelpEventsEventIdViewGet200Response> helpEventsEventIdViewGet(String eventId) async
    test('test helpEventsEventIdViewGet', () async {
      // TODO
    });

    // List nearby help events
    //
    //Future<HelpEventsNearbyGet200Response> helpEventsNearbyGet(num lat, num lng, { int accuracy }) async
    test('test helpEventsNearbyGet', () async {
      // TODO
    });

    // Create a new help event
    //
    //Future<HelpEventsPost201Response> helpEventsPost(HelpEventCreate helpEventCreate) async
    test('test helpEventsPost', () async {
      // TODO
    });

  });
}
