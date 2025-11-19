import '../repositories/help_repository.dart';

/// Use case for cancelling a help request.
class CancelHelpUseCase {
  final HelpRepository _repository;

  CancelHelpUseCase(this._repository);

  /// Cancel an active help request.
  Future<void> execute(String requestId) async {
    return _repository.cancelHelp(requestId);
  }
}

