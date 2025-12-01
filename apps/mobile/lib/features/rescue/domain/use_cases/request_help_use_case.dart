import '../models/index.dart';
import '../repositories/help_repository.dart';

/// Use case for requesting help.
/// Encapsulates the business logic for creating a help request.
class RequestHelpUseCase {
  final HelpRepository _repository;

  RequestHelpUseCase(this._repository);

  /// Request help with the specified need type and location.
  Future<HelpResponse> execute({
    required HelpNeedType needType,
    required Location location,
  }) async {
    final request = HelpRequest(
      needType: needType,
      location: location,
    );
    return _repository.requestHelp(request);
  }
}

