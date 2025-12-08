import 'package:flutter_test/flutter_test.dart';
import 'package:lumisovellus/features/rescue/data/services/help_service_stub.dart';
import 'package:lumisovellus/features/rescue/data/services/help_service.dart';
import 'package:lumisovellus/features/rescue/domain/models/help_need_type.dart';

void main() {
  test('StubHelpService stores requests and returns response', () async {
    final store = InMemoryHelpStore();
    final service = StubHelpService(store);

    final resp = await service.requestHelp(
      ServiceHelpRequest(needType: HelpNeedType.health),
    );

    expect(store.requests.length, 1);
    expect(store.responses.containsKey(resp.requestId), isTrue);
  });

  test('StubHelpService cancelHelp removes response', () async {
    final store = InMemoryHelpStore();
    final service = StubHelpService(store);

    final resp = await service.requestHelp(
      ServiceHelpRequest(needType: HelpNeedType.equipment),
    );
    expect(store.responses.containsKey(resp.requestId), isTrue);

    await service.cancelHelp(resp.requestId);
    expect(store.responses.containsKey(resp.requestId), isFalse);
  });
}


