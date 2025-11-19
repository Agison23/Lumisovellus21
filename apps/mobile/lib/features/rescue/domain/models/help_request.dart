import 'help_need_type.dart';
import 'location.dart';

class HelpRequest {
  final HelpNeedType needType;
  final Location? location;

  const HelpRequest({
    required this.needType,
    this.location,
  });
}

