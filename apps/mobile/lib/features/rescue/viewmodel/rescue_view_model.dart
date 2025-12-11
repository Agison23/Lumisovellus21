import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../domain/models/index.dart';
import '../domain/use_cases/request_help_use_case.dart';
import '../domain/use_cases/cancel_help_use_case.dart';
import '../domain/use_cases/complete_help_use_case.dart';
import '../providers.dart';
import 'package:lumisovellus/core/errors/error_message_helper.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';

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

/// Provider for rescue error messages (used for snackbars)
final rescueErrorProvider = StateProvider<String?>((ref) => null);

/// ViewModel for the rescue page
class RescueViewModel extends StateNotifier<RescueState> {
  final RequestHelpUseCase _requestHelpUseCase;
  final CancelHelpUseCase _cancelHelpUseCase;
  final CompleteHelpUseCase _completeHelpUseCase;
  final Ref _ref;

  RescueViewModel({
    required RequestHelpUseCase requestHelpUseCase,
    required CancelHelpUseCase cancelHelpUseCase,
    required CompleteHelpUseCase completeHelpUseCase,
    required Ref ref,
  })  : _requestHelpUseCase = requestHelpUseCase,
        _cancelHelpUseCase = cancelHelpUseCase,
        _completeHelpUseCase = completeHelpUseCase,
        _ref = ref,
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
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

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
  /// 
  /// [localizations] is required to generate localized error messages.
  Future<void> requestHelp(
    HelpNeedType needType,
    AppLocalizations localizations,
  ) async {
    if (state.currentPosition == null) {
      _ref.read(rescueErrorProvider.notifier).state =
          localizations.locationNotAvailable;
      return;
    }

      state = state.copyWith(
        isLoadingHelpOperation: true,
        clearErrorMessage: true,
      );
    _ref.read(rescueErrorProvider.notifier).state = null; // Clear previous errors

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
      _ref.read(rescueErrorProvider.notifier).state = null;
    } catch (e) {
      state = state.copyWith(
        isLoadingHelpOperation: false,
      );
      _ref.read(rescueErrorProvider.notifier).state =
          ErrorMessageHelper.getHelpRequestErrorMessage(
        e,
        localizations,
      );
    }
  }

  /// Cancel the active help event
  /// 
  /// [localizations] is required to generate localized error messages.
  Future<void> cancelHelpEvent(AppLocalizations localizations) async {
    if (state.activeHelpEvent == null) return;

    state = state.copyWith(
      isLoadingHelpOperation: true,
      clearErrorMessage: true,
    );
    _ref.read(rescueErrorProvider.notifier).state = null;

    try {
      await _cancelHelpUseCase.execute(state.activeHelpEvent!.requestId);
      state = state.copyWith(
        clearActiveEvent: true,
        isLoadingHelpOperation: false,
        clearErrorMessage: true,
      );
      _ref.read(rescueErrorProvider.notifier).state = null;
    } catch (e) {
      state = state.copyWith(
        isLoadingHelpOperation: false,
      );
      _ref.read(rescueErrorProvider.notifier).state =
          ErrorMessageHelper.getCancelHelpErrorMessage(
        e,
        localizations,
      );
    }
  }

  /// Complete the active help event
  /// 
  /// [localizations] is required to generate localized error messages.
  Future<void> completeHelpEvent(AppLocalizations localizations) async {
    if (state.activeHelpEvent == null) return;

    state = state.copyWith(
      isLoadingHelpOperation: true,
      clearErrorMessage: true,
    );
    _ref.read(rescueErrorProvider.notifier).state = null;

    try {
      await _completeHelpUseCase.execute(state.activeHelpEvent!.requestId);
      state = state.copyWith(
        clearActiveEvent: true,
        isLoadingHelpOperation: false,
        clearErrorMessage: true,
      );
      _ref.read(rescueErrorProvider.notifier).state = null;
    } catch (e) {
      state = state.copyWith(
        isLoadingHelpOperation: false,
      );
      _ref.read(rescueErrorProvider.notifier).state =
          ErrorMessageHelper.getCompleteHelpErrorMessage(
        e,
        localizations,
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
    ref: ref,
  );
});

