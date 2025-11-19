import 'help_service.dart';

class BackendHelpService implements HelpService {
  BackendHelpService({required this.baseUrl});
  final String baseUrl;

  @override
  Future<ServiceHelpResponse> requestHelp(ServiceHelpRequest request) async {
    // TODO: Implement real network call to "$baseUrl/help-requests"
    // This will use the auto-generated API client when API is finalized
    throw UnimplementedError('BackendHelpService.requestHelp not implemented');
  }

  @override
  Future<void> cancelHelp(String requestId) async {
    // TODO: Implement real network call to "$baseUrl/help-requests/$requestId"
    throw UnimplementedError('BackendHelpService.cancelHelp not implemented');
  }
}
