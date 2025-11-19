import 'help_need_type.dart';
import 'help_event_status.dart';
import 'location.dart';

class HelpResponse {
  final String requestId;
  final DateTime createdAt;
  final HelpNeedType needType;
  final HelpEventStatus status;
  final int notifiedNearbyCount;
  final Location location;

  const HelpResponse({
    required this.requestId,
    required this.createdAt,
    required this.needType,
    required this.status,
    required this.notifiedNearbyCount,
    required this.location,
  });
}

