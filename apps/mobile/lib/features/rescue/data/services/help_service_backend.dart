import 'package:lumisovellus/core/network/api_client.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';
import 'help_service.dart';
import '../../domain/models/help_need_type.dart';
import '../../domain/models/help_event_status.dart';

class BackendHelpService implements HelpService {
  BackendHelpService({required this.apiClient});
  final ApiClient apiClient;

  // Helper function to map domain HelpNeedType to API enum
  HelpEventCreateNeedTypeEnum _mapNeedTypeToApi(HelpNeedType needType) {
    switch (needType) {
      case HelpNeedType.health:
        return HelpEventCreateNeedTypeEnum.health;
      case HelpNeedType.equipment:
        return HelpEventCreateNeedTypeEnum.equipment;
      case HelpNeedType.lost:
        return HelpEventCreateNeedTypeEnum.lost;
    }
  }

  // Helper function to map API status enum to domain HelpEventStatus
  HelpEventStatus _mapStatusFromApi(HelpEventRescueeViewStatusEnum status) {
    switch (status) {
      case HelpEventRescueeViewStatusEnum.active:
        return HelpEventStatus.active;
      case HelpEventRescueeViewStatusEnum.completed:
        return HelpEventStatus.completed;
      case HelpEventRescueeViewStatusEnum.cancelled:
        return HelpEventStatus.cancelled;
    }
  }

  @override
  Future<ServiceHelpResponse> requestHelp(ServiceHelpRequest request) async {
    if (request.latitude == null || request.longitude == null) {
      throw ArgumentError('Location (latitude and longitude) is required');
    }

    // Map domain needType to API enum
    final apiNeedType = _mapNeedTypeToApi(request.needType as HelpNeedType);

    // Create location object
    final location = HelpEventLocation(
      latitude: request.latitude!,
      longitude: request.longitude!,
      accuracy: request.accuracyMeters,
    );

    // Create help event request
    final helpEventCreate = HelpEventCreate(
      // timestamp: DateTime.now().millisecondsSinceEpoch,
      timestamp: (DateTime.now().millisecondsSinceEpoch ~/ 1000),
      location: location,
      needType: apiNeedType,
      chatRoomId:
          "room-123", // TODO: chatroom ID shouldn't be created by frontend. Leaving this here to avoid errors for now.
    );

    // Call API
    final response = await apiClient.helpEvents.helpEventsPost(
      helpEventCreate: helpEventCreate,
    );

    final responseData = response.data;
    if (responseData == null || !responseData.success) {
      throw Exception('Failed to create help event');
    }

    final eventData = responseData.data;

    // Map API response to service model
    return ServiceHelpResponse(
      requestId: eventData.eventId,
      createdAt: eventData.createdAt,
      needType: request.needType, // Keep original domain type
      status: _mapStatusFromApi(eventData.status),
      notifiedNearbyCount: eventData.rescuerCount,
      latitude: eventData.location.latitude.toDouble(),
      longitude: eventData.location.longitude.toDouble(),
      accuracy: eventData.location.accuracy?.toDouble(),
    );
  }

  @override
  Future<void> cancelHelp(String requestId) async {
    final statusUpdate = HelpEventStatusUpdate(
      status: HelpEventStatusUpdateStatusEnum.cancelled,
    );

    var response = await apiClient.helpEvents.helpEventsEventIdPatch(
      eventId: requestId,
      helpEventStatusUpdate: statusUpdate,
    );
  }

  @override
  Future<void> completeHelp(String requestId) async {
    final statusUpdate = HelpEventStatusUpdate(
      status: HelpEventStatusUpdateStatusEnum.completed,
    );

    var response = await apiClient.helpEvents.helpEventsEventIdPatch(
      eventId: requestId,
      helpEventStatusUpdate: statusUpdate,
    );
  }
}
