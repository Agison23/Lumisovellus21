import '../models/index.dart';

/// Repository interface for help/rescue operations.
/// Abstracts away the data layer implementation details.
abstract class HelpRepository {
  /// Request help with the specified need type and location.
  Future<HelpResponse> requestHelp(HelpRequest request);

  /// Cancel an active help request.
  Future<void> cancelHelpEvent(String requestId);

  /// Complete an active help event.
  Future<void> completeHelpEvent(String requestId);
  
}

