/// Service interface for help operations.
/// This layer works with service-specific models (which may come from API).
/// The repository layer maps between these and domain models.
abstract class HelpService {
  Future<ServiceHelpResponse> requestHelp(ServiceHelpRequest request);
  Future<void> cancelHelp(String requestId);
  Future<void> completeHelp(String requestId);
}

/// Service models - these will be replaced with API models when finalized.
/// These are internal to the data layer and should not be used by domain/UI layers.
class ServiceHelpRequest {
  final dynamic needType; // Will be HelpNeedType from domain
  final double? latitude;
  final double? longitude;
  final double? accuracyMeters;

  ServiceHelpRequest({
    required this.needType,
    this.latitude,
    this.longitude,
    this.accuracyMeters,
  });
}

class ServiceHelpResponse {
  final String requestId;
  final DateTime createdAt;
  final dynamic needType; // Will be HelpNeedType from domain
  final dynamic status; // Will be HelpEventStatus from domain
  final int notifiedNearbyCount;
  final double latitude;
  final double longitude;
  final double? accuracy;

  ServiceHelpResponse({
    required this.requestId,
    required this.createdAt,
    required this.needType,
    required this.status,
    required this.notifiedNearbyCount,
    required this.latitude,
    required this.longitude,
    this.accuracy,
  });
}

