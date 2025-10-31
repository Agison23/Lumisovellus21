import 'dart:async';
import '../model/help_models.dart';

class InMemoryHelpStore {
  final List<HelpRequest> requests = <HelpRequest>[];
  final Map<String, HelpResponse> responses = <String, HelpResponse>{};
}

class FakeHelpService implements HelpService {
  FakeHelpService(this._store);

  final InMemoryHelpStore _store;

  @override
  Future<HelpResponse> requestHelp(HelpRequest request) async {
    _store.requests.add(request);
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final response = HelpResponse(
      requestId: DateTime.now().microsecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      accepted: true,
      message: 'Help request queued',
    );
    _store.responses[response.requestId] = response;
    return response;
  }

  @override
  Future<void> cancelHelp(String requestId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    _store.responses.remove(requestId);
  }
}


