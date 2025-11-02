enum HelpNeedType {
  health,
  equipment,
  lost,
}

class HelpRequest {
  final HelpNeedType needType;
  final double? latitude;
  final double? longitude;
  final double? accuracyMeters;

  const HelpRequest({
    required this.needType,
    this.latitude,
    this.longitude,
    this.accuracyMeters,
  });
}

class HelpResponse {
  final String requestId;
  final DateTime createdAt;
  final HelpNeedType needType;
  final bool active;
  final int notifiedNearbyCount;

  const HelpResponse({
    required this.requestId,
    required this.createdAt,
    required this.needType,
    required this.active,
    required this.notifiedNearbyCount,
  });
}

class HelpAcceptance {

}

abstract class HelpService {
  Future<HelpResponse> requestHelp(HelpRequest request);
  Future<void> cancelHelp(String requestId);
}
