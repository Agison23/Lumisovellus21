import 'help_need_type.dart';

class HelpResponse {
  final String requestId;
  final DateTime createdAt;
  final HelpNeedType needType;
  final bool active;
  final int rescuerCount;

  const HelpResponse({
    required this.requestId,
    required this.createdAt,
    required this.needType,
    required this.active,
    required this.rescuerCount,
  });
}

