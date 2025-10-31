import 'package:flutter_test/flutter_test.dart';
import 'package:lumisovellus/features/rescue/data/help_service_fake.dart';
import 'package:lumisovellus/features/rescue/model/help_models.dart';

void main() {
  test('FakeHelpService stores requests and returns response', () async {
    final store = InMemoryHelpStore();
    final service = FakeHelpService(store);

    final resp = await service.requestHelp(
      const HelpRequest(needType: HelpNeedType.health),
    );

    expect(store.requests.length, 1);
    expect(store.responses.containsKey(resp.requestId), isTrue);
    expect(resp.accepted, isTrue);
  });

  test('FakeHelpService cancelHelp removes response', () async {
    final store = InMemoryHelpStore();
    final service = FakeHelpService(store);

    final resp = await service.requestHelp(
      const HelpRequest(needType: HelpNeedType.equipment),
    );
    expect(store.responses.containsKey(resp.requestId), isTrue);

    await service.cancelHelp(resp.requestId);
    expect(store.responses.containsKey(resp.requestId), isFalse);
  });
}


