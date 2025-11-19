import 'dart:async';
import 'help_service.dart';

class InMemoryHelpStore {
  final List<ServiceHelpRequest> requests = <ServiceHelpRequest>[];
  final Map<String, ServiceHelpResponse> responses = <String, ServiceHelpResponse>{};
}

class FakeHelpService implements HelpService {
  FakeHelpService(this._store);

  final InMemoryHelpStore _store;

  @override
  Future<ServiceHelpResponse> requestHelp(ServiceHelpRequest request) async {
    _store.requests.add(request);
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final response = ServiceHelpResponse(
      requestId: DateTime.now().microsecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      needType: request.needType,
      active: true,
      notifiedNearbyCount: 3,
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


