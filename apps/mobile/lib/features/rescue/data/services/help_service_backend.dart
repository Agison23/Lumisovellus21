import '../../model/help_models.dart';

class BackendHelpService implements HelpService {
  BackendHelpService({required this.baseUrl});
  final String baseUrl;

  @override
  Future<HelpResponse> requestHelp(HelpRequest request) async {
    // TODO: Implement real network call to "$baseUrl/help-requests"
    throw UnimplementedError('BackendHelpService.requestHelp not implemented');
  }

  @override
  Future<void> cancelHelp(String requestId) async {
    // TODO: Implement real network call to "$baseUrl/help-requests/$requestId"
    throw UnimplementedError('BackendHelpService.cancelHelp not implemented');
  }
}
