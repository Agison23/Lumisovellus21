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
  final bool accepted;
  final String? message;

  const HelpResponse({
    required this.requestId,
    required this.createdAt,
    required this.accepted,
    this.message,
  });
}

abstract class HelpService {
  Future<HelpResponse> requestHelp(HelpRequest request);
  Future<void> cancelHelp(String requestId);
}


