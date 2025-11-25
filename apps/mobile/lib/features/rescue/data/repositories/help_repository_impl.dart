import '../../domain/models/index.dart';
import '../../domain/repositories/help_repository.dart';
import '../services/help_service.dart';
import '../mappers/rescue_mapper.dart';

/// Implementation of HelpRepository that delegates to HelpService.
/// This layer maps between domain models and service models.
class HelpRepositoryImpl implements HelpRepository {
  final HelpService _service;
  final RescueMappr _mapper = RescueMappr();

  HelpRepositoryImpl(this._service);

  @override
  Future<HelpResponse> requestHelp(HelpRequest request) async {
    // Map domain model to service model
    final serviceRequest = _mapper.convert<HelpRequest, ServiceHelpRequest>(request);

    final serviceResponse = await _service.requestHelp(serviceRequest);

    // Map service model back to domain model
    return _mapper.convert<ServiceHelpResponse, HelpResponse>(serviceResponse);
  }

  @override
  Future<void> cancelHelpEvent(String requestId) async {
    await _service.cancelHelp(requestId);
  }

  @override
  Future<void> completeHelpEvent(String requestId) async {
    await _service.completeHelp(requestId);
  }
}
