import 'dart:async';
import 'help_service.dart';
import '../../domain/models/help_event_status.dart';

class InMemoryHelpStore {
  final List<ServiceHelpRequest> requests = <ServiceHelpRequest>[];
  final Map<String, ServiceHelpResponse> responses = <String, ServiceHelpResponse>{};
}

class StubHelpService implements HelpService {
  StubHelpService(this._store);

  final InMemoryHelpStore _store;

  @override
  Future<ServiceHelpResponse> requestHelp(ServiceHelpRequest request) async {
    _store.requests.add(request);
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final response = ServiceHelpResponse(
      requestId: DateTime.now().microsecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      needType: request.needType,
      status: HelpEventStatus.active,
      notifiedNearbyCount: 3,
      latitude: request.latitude ?? 0.0,
      longitude: request.longitude ?? 0.0,
      accuracy: request.accuracyMeters,
    );
    _store.responses[response.requestId] = response;
    return response;
  }

  @override
  Future<void> cancelHelp(String requestId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    _store.responses.remove(requestId);
  }

  @override
  Future<void> completeHelp(String requestId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final response = _store.responses[requestId];
    if (response != null) {
      _store.responses[requestId] = ServiceHelpResponse(
        requestId: response.requestId,
        createdAt: response.createdAt,
        needType: response.needType,
        status: HelpEventStatus.completed,
        notifiedNearbyCount: response.notifiedNearbyCount,
        latitude: response.latitude,
        longitude: response.longitude,
        accuracy: response.accuracy,
      );
    }
  }
}

