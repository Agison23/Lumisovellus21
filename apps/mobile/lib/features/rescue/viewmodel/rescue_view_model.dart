import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../domain/models/index.dart';
import '../domain/use_cases/request_help_use_case.dart';
import '../domain/use_cases/cancel_help_use_case.dart';
import '../domain/use_cases/complete_help_use_case.dart';
import '../providers.dart';

/// State for the rescue page
class RescueState {
  final Position? currentPosition;
  final bool isLoadingLocation;
  final HelpResponse? activeHelpEvent;
  final bool isLoadingHelpOperation;
  final String? errorMessage;

  const RescueState({
    this.currentPosition,
    this.isLoadingLocation = false,
    this.activeHelpEvent,
    this.isLoadingHelpOperation = false,
    this.errorMessage,
  });

  bool get hasActiveEvent => activeHelpEvent != null &&
      activeHelpEvent!.status == HelpEventStatus.active;

  RescueState copyWith({
    Position? currentPosition,
    bool? isLoadingLocation,
    HelpResponse? activeHelpEvent,
    bool? isLoadingHelpOperation,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool clearActiveEvent = false,
  }) {
    return RescueState(
      currentPosition: currentPosition ?? this.currentPosition,
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
      activeHelpEvent: clearActiveEvent ? null : (activeHelpEvent ?? this.activeHelpEvent),
      isLoadingHelpOperation: isLoadingHelpOperation ?? this.isLoadingHelpOperation,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// ViewModel for the rescue page
class RescueViewModel extends StateNotifier<RescueState> {
  final RequestHelpUseCase _requestHelpUseCase;
  final CancelHelpUseCase _cancelHelpUseCase;
  final CompleteHelpUseCase _completeHelpUseCase;

  RescueViewModel({
    required RequestHelpUseCase requestHelpUseCase,
    required CancelHelpUseCase cancelHelpUseCase,
    required CompleteHelpUseCase completeHelpUseCase,
  })  : _requestHelpUseCase = requestHelpUseCase,
        _cancelHelpUseCase = cancelHelpUseCase,
        _completeHelpUseCase = completeHelpUseCase,
        super(const RescueState()) {
    _getCurrentLocation();
  }

  /// Get the current location
  Future<void> _getCurrentLocation() async {
    state = state.copyWith(isLoadingLocation: true, clearErrorMessage: true);

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(
          isLoadingLocation: false,
          errorMessage: 'Location services are disabled',
        );
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          state = state.copyWith(
            isLoadingLocation: false,
            errorMessage: 'Location permission denied',
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        state = state.copyWith(
          isLoadingLocation: false,
          errorMessage: 'Location permission permanently denied',
        );
        return;
      }

      // Get current position
      // MOCK: Using a mocked position with 3-digit longitude for testing
      final Position position = Position(
        latitude: 60.123456,
        longitude: 123.456789, // 3-digit longitude
        timestamp: DateTime(2024, 1, 1),
        accuracy: 5.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        isMocked: true,
      );

      // Uncomment below to use real Geolocator instead of mock:
      // Position position = await Geolocator.getCurrentPosition(
      //   locationSettings: const LocationSettings(
      //     accuracy: LocationAccuracy.high,
      //   ),
      // );

      state = state.copyWith(
        currentPosition: position,
        isLoadingLocation: false,
        clearErrorMessage: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingLocation: false,
        errorMessage: 'Failed to get location: $e',
      );
    }
  }

  /// Refresh the current location
  Future<void> refreshLocation() async {
    await _getCurrentLocation();
  }

  /// Request help with the specified need type
  Future<void> requestHelp(HelpNeedType needType) async {
    if (state.currentPosition == null) {
      state = state.copyWith(
        errorMessage: 'Location not available',
      );
      return;
    }

    state = state.copyWith(
      isLoadingHelpOperation: true,
      clearErrorMessage: true,
    );

    try {
      final location = Location(
        latitude: state.currentPosition!.latitude,
        longitude: state.currentPosition!.longitude,
        accuracy: state.currentPosition!.accuracy,
      );

      final response = await _requestHelpUseCase.execute(
        needType: needType,
        location: location,
      );

      state = state.copyWith(
        activeHelpEvent: response,
        isLoadingHelpOperation: false,
        clearErrorMessage: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingHelpOperation: false,
        errorMessage: 'Failed to request help: $e',
      );
    }
  }

  /// Cancel the active help event
  Future<void> cancelHelpEvent() async {
    if (state.activeHelpEvent == null) return;

    state = state.copyWith(
      isLoadingHelpOperation: true,
      clearErrorMessage: true,
    );

    try {
      await _cancelHelpUseCase.execute(state.activeHelpEvent!.requestId);
      state = state.copyWith(
        clearActiveEvent: true,
        isLoadingHelpOperation: false,
        clearErrorMessage: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingHelpOperation: false,
        errorMessage: 'Failed to cancel help event: $e',
      );
    }
  }

  /// Complete the active help event
  Future<void> completeHelpEvent() async {
    if (state.activeHelpEvent == null) return;

    state = state.copyWith(
      isLoadingHelpOperation: true,
      clearErrorMessage: true,
    );

    try {
      await _completeHelpUseCase.execute(state.activeHelpEvent!.requestId);
      state = state.copyWith(
        clearActiveEvent: true,
        isLoadingHelpOperation: false,
        clearErrorMessage: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingHelpOperation: false,
        errorMessage: 'Failed to complete help event: $e',
      );
    }
  }
}

/// Provider for the rescue view model
final rescueViewModelProvider =
    StateNotifierProvider<RescueViewModel, RescueState>((ref) {
  return RescueViewModel(
    requestHelpUseCase: ref.watch(requestHelpUseCaseProvider),
    cancelHelpUseCase: ref.watch(cancelHelpUseCaseProvider),
    completeHelpUseCase: ref.watch(completeHelpUseCaseProvider),
  );
});

