import '../../domain/models/index.dart';
import '../../domain/repositories/help_repository.dart';
import '../services/help_service.dart';

/// Implementation of HelpRepository that delegates to HelpService.
/// This layer maps between domain models and service models.
class HelpRepositoryImpl implements HelpRepository {
  final HelpService _service;

  HelpRepositoryImpl(this._service);

  @override
  Future<HelpResponse> requestHelp(HelpRequest request) async {
    // Map domain model to service model
    final serviceRequest = ServiceHelpRequest(
      needType: request.needType,
      latitude: request.location?.latitude,
      longitude: request.location?.longitude,
      accuracyMeters: request.location?.accuracy,
    );

    final serviceResponse = await _service.requestHelp(serviceRequest);

    // Map service model back to domain model
    return HelpResponse(
      requestId: serviceResponse.requestId,
      createdAt: serviceResponse.createdAt,
      needType: serviceResponse.needType as HelpNeedType,
      active: serviceResponse.active,
      rescuerCount: serviceResponse.notifiedNearbyCount,
    );
  }

  @override
  Future<void> cancelHelp(String requestId) async {
    await _service.cancelHelp(requestId);
  }
}

