import '../repositories/help_repository.dart';

/// Use case for completing a help request.
class CompleteHelpUseCase {
  final HelpRepository _repository;

  CompleteHelpUseCase(this._repository);

  /// Complete an active help request.
  Future<void> execute(String requestId) async {
    return _repository.completeHelpEvent(requestId);
  }
}

