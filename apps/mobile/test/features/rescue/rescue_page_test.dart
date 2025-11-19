import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumisovellus/features/rescue/domain/models/index.dart';
import 'package:lumisovellus/features/rescue/domain/repositories/help_repository.dart';
import 'package:lumisovellus/features/rescue/providers.dart';
import 'package:geolocator/geolocator.dart';
import '../../test_utils/pump_rescue.dart';

class RecordingHelpRepository implements HelpRepository {
  HelpRequest? lastRequest;
  bool shouldThrow = false;

  @override
  Future<HelpResponse> requestHelp(HelpRequest r) async {
    lastRequest = r;
    if (shouldThrow) {
      throw Exception('network');
    }
    return HelpResponse(
      requestId: 'id-1',
      createdAt: DateTime(2024, 1, 1),
      needType: HelpNeedType.health,
      active: true,
      rescuerCount: 4,
    );
  }

  @override
  Future<void> cancelHelp(String requestId) async {}
}

void main() {
  // No global Geolocator override; each test prepares its own scenario.

  testWidgets('shows error when no need selected', (tester) async {
    await pumpRescueWithFakeLocation(
      tester,
      serviceEnabled: true,
      permission: LocationPermission.deniedForever,
      position: null,
    );

    final requestBtn = find.byKey(const ValueKey('rescue.requestHelpButton'));
    await tester.ensureVisible(requestBtn);
    await tester.tap(requestBtn);
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('requests help after confirm and shows success', (tester) async {
    final recording = RecordingHelpRepository();
    await pumpRescueWithFakeLocation(
      tester,
      serviceEnabled: true,
      permission: LocationPermission.deniedForever,
      position: null,
      overrides: [helpRepositoryProvider.overrideWithValue(recording)],
    );

    final needHealth = find.byKey(const ValueKey('rescue.need.health'));
    await tester.ensureVisible(needHealth);
    await tester.tap(needHealth);
    await tester.pump();

    final requestBtn2 = find.byKey(const ValueKey('rescue.requestHelpButton'));
    await tester.ensureVisible(requestBtn2);
    await tester.tap(requestBtn2);
    await tester.pumpAndSettle();

    final okBtn = find.byKey(const ValueKey('rescue.confirm.ok'));
    await tester.ensureVisible(okBtn);
    await tester.tap(okBtn);
    await tester.pumpAndSettle();

    expect(recording.lastRequest, isNotNull);
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('shows error SnackBar when service throws', (tester) async {
    final recording = RecordingHelpRepository()..shouldThrow = true;
    await pumpRescueWithFakeLocation(
      tester,
      serviceEnabled: true,
      permission: LocationPermission.deniedForever,
      position: null,
      overrides: [helpRepositoryProvider.overrideWithValue(recording)],
    );

    final needHealth2 = find.byKey(const ValueKey('rescue.need.health'));
    await tester.ensureVisible(needHealth2);
    await tester.tap(needHealth2);
    await tester.pump();

    final requestBtn3 = find.byKey(const ValueKey('rescue.requestHelpButton'));
    await tester.ensureVisible(requestBtn3);
    await tester.tap(requestBtn3);
    await tester.pumpAndSettle();

    final okBtn2 = find.byKey(const ValueKey('rescue.confirm.ok'));
    await tester.ensureVisible(okBtn2);
    await tester.tap(okBtn2);
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('displays current location when available', (tester) async {
    await pumpRescueWithFakeLocation(
      tester,
      serviceEnabled: true,
      permission: LocationPermission.always,
      position: Position(
        latitude: 60.123456,
        longitude: 24.654321,
        timestamp: DateTime(2024),
        accuracy: 5.0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      ),
    );

    expect(find.textContaining('60.123456'), findsOneWidget);
    expect(find.textContaining('24.654321'), findsOneWidget);
  });

  testWidgets('shows not available when permissions denied', (tester) async {
    await pumpRescueWithFakeLocation(
      tester,
      serviceEnabled: true,
      permission: LocationPermission.deniedForever,
      position: null,
    );

    expect(find.textContaining('Latitude'), findsNothing);
    expect(find.textContaining('Longitude'), findsNothing);
  });
}
