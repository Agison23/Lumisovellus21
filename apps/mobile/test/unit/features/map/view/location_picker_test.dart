import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:lumisovellus/features/map/views/widgets/location_picker.dart';

void main() {
  group('LocateButton', () {
    testWidgets('renders my_location icon and calls onLocate when tapped', (
      tester,
    ) async {
      bool called = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(child: LocateButton(onLocate: () => called = true)),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.my_location), findsOneWidget);

      await tester.tap(find.byType(LocateButton));
      await tester.pumpAndSettle();

      expect(called, isTrue);
    });
  });

  group('PlacesButton', () {
    testWidgets('renders travel_explore icon', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(child: PlacesButton(onLocationSelected: (_) {})),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.travel_explore), findsOneWidget);
    });

    testWidgets('shows place options and calls onLocationSelected', (
      tester,
    ) async {
      CameraOptions? selected;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: PlacesButton(onLocationSelected: (c) => selected = c),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(PlacesButton));
      await tester.pumpAndSettle();

      final placeItem = find.text('Pallastunturi');
      expect(placeItem, findsOneWidget);

      await tester.tap(placeItem);
      await tester.pumpAndSettle();

      expect(selected, isNotNull);
      expect(selected!.zoom, 12);
      expect(selected!.pitch, 60);
      expect(selected!.bearing, 0);
    });
  });
}
