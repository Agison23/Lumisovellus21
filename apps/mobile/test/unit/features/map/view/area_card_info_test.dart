import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';
import 'package:lumisovellus/features/map/views/widgets/area_card_info.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';

SnowType _snowType({
  required String id,
  required String identifier,
  required String name,
  required String colour,
  int? skiability,
  String? primarySnowTypeId,
  String? explanation,
}) {
  return SnowType(
    id: id,
    identifier: identifier,
    name: name,
    colour: colour,
    skiability: skiability,
    primarySnowTypeId: primarySnowTypeId,
    explanation: explanation,
  );
}

Future<void> _pumpAreaCardInfo(
  WidgetTester tester, {
  required String danger,
  required List<SnowType> snowTypes,
  required GuideUpdateRequestOutput? guideUpdate,
  required List<SegmentUserReview> userReviews,
  required VoidCallback onAdd,
  required VoidCallback onClose,
  required bool canAddObservation,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          final t = AppLocalizations.of(context);
          return Scaffold(
            body: AreaCardInfo(
              t: t,
              danger: danger,
              snowTypes: snowTypes,
              guideUpdate: guideUpdate,
              userReviews: userReviews,
              onAdd: onAdd,
              onClose: onClose,
              canAddObservation: canAddObservation,
            ),
          );
        },
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('AreaCardInfo', () {
    testWidgets('shows danger text and both buttons when adding is allowed', (
      tester,
    ) async {
      bool addPressed = false;
      bool closePressed = false;

      const danger = 'Lumivyöryvaara 2';
      final snowTypes = [
        _snowType(
          id: 'uusi_lumi',
          identifier: 'uusi_lumi',
          name: 'Uusi lumi',
          colour: '#5AABED',
          skiability: 4,
          primarySnowTypeId: null,
          explanation: 'Vastasatanut pehmeä lumi.',
        ),
      ];

      await _pumpAreaCardInfo(
        tester,
        danger: danger,
        snowTypes: snowTypes,
        guideUpdate: null,
        userReviews: const [],
        onAdd: () => addPressed = true,
        onClose: () => closePressed = true,
        canAddObservation: true,
      );

      expect(find.text(danger), findsOneWidget);

      final context = tester.element(find.byType(AreaCardInfo));
      final t = AppLocalizations.of(context);

      final addButtonFinder = find.widgetWithText(
        ElevatedButton,
        t.addObservation,
      );
      final closeButtonFinder = find.widgetWithText(ElevatedButton, t.close);

      expect(addButtonFinder, findsOneWidget);
      expect(closeButtonFinder, findsOneWidget);

      await tester.tap(addButtonFinder);
      await tester.pumpAndSettle();
      expect(addPressed, true);

      await tester.tap(closeButtonFinder);
      await tester.pumpAndSettle();
      expect(closePressed, true);
    });

    testWidgets('hides add button when canAddObservation is false', (
      tester,
    ) async {
      bool addPressed = false;
      bool closePressed = false;

      await _pumpAreaCardInfo(
        tester,
        danger: 'Lumivyöryvaara 1',
        snowTypes: const [],
        guideUpdate: null,
        userReviews: const [],
        onAdd: () => addPressed = true,
        onClose: () => closePressed = true,
        canAddObservation: false,
      );

      final context = tester.element(find.byType(AreaCardInfo));
      final t = AppLocalizations.of(context);

      final addButtonFinder = find.widgetWithText(
        ElevatedButton,
        t.addObservation,
      );
      final closeButtonFinder = find.widgetWithText(ElevatedButton, t.close);

      expect(addButtonFinder, findsNothing);
      expect(closeButtonFinder, findsOneWidget);

      await tester.tap(closeButtonFinder);
      await tester.pumpAndSettle();
      expect(closePressed, true);
      expect(addPressed, false);
    });
  });
}
