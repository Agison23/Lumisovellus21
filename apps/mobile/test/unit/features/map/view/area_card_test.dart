import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';
import 'package:lumisovellus/features/map/views/widgets/area_card.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';
import 'package:lumisovellus/core/auth/viewmodel/auth_notifier.dart';

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

Future<void> _pumpAreaCard(
  WidgetTester tester, {
  required bool loggedIn,
  required List<SnowType> snowTypes,
  required List<String> hazards,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        loggedInRoleProvider.overrideWithValue(loggedIn ? 'normal' : null),
      ],
      child: MaterialApp(
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
              body: Center(
                child: AreaCard(
                  t: t,
                  segmentId: 'seg-1',
                  name: 'Laukukero itäseinä',
                  terrain: 'Tuulikangas ja varvikko',
                  danger: 'Lumivyöryvaara 2',
                  onAdd: () {},
                  onClose: () {},
                  snowTypes: snowTypes,
                  hazards: hazards,
                  userReviews: const [],
                  guideUpdate: null,
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  final snowTypes = [
    _snowType(
      id: 'korppu',
      identifier: 'korppu',
      name: 'Korppu',
      colour: '#3838a0',
      skiability: 3,
      primarySnowTypeId: null,
      explanation: 'Kova hangen pinnalla oleva kansi.',
    ),
    _snowType(
      id: 'uusi_lumi',
      identifier: 'uusi_lumi',
      name: 'Uusi lumi',
      colour: '#5AABED',
      skiability: 4,
      primarySnowTypeId: null,
      explanation: 'Vastasatanut pehmeä lumi.',
    ),
    _snowType(
      id: 'vitilumi',
      identifier: 'vitilumi',
      name: 'Vitilumi',
      colour: '#5AABED',
      skiability: 5,
      primarySnowTypeId: 'uusi_lumi',
      explanation:
          'Vastasatanutta, kevyttä, pehmeää ja hieman tiivistyvää pakkaslunta.',
    ),
  ];

  group('AreaCard', () {
    testWidgets('shows name, terrain and hides add button when logged out', (
      tester,
    ) async {
      await _pumpAreaCard(
        tester,
        loggedIn: false,
        snowTypes: snowTypes,
        hazards: const ['stones', 'branches'],
      );

      expect(find.text('Laukukero itäseinä'), findsOneWidget);
      expect(find.text('Tuulikangas ja varvikko'), findsOneWidget);

      final context = tester.element(find.byType(AreaCard));
      final t = AppLocalizations.of(context);

      final addButtonFinder = find.widgetWithText(
        ElevatedButton,
        t.addObservation,
      );
      final closeButtonFinder = find.widgetWithText(ElevatedButton, t.close);

      expect(addButtonFinder, findsNothing);
      expect(closeButtonFinder, findsOneWidget);
    });

    testWidgets('shows add button and goes to category step when tapped', (
      tester,
    ) async {
      await _pumpAreaCard(
        tester,
        loggedIn: true,
        snowTypes: snowTypes,
        hazards: const ['stones', 'branches'],
      );

      final context = tester.element(find.byType(AreaCard));
      final t = AppLocalizations.of(context);

      final addButtonFinder = find.widgetWithText(
        ElevatedButton,
        t.addObservation,
      );

      expect(addButtonFinder, findsOneWidget);

      await tester.tap(addButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text(t.selectSnowType), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Korppu'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Uusi lumi'), findsOneWidget);
    });

    testWidgets('navigates category → type selection and back', (tester) async {
      await _pumpAreaCard(
        tester,
        loggedIn: true,
        snowTypes: snowTypes,
        hazards: const ['stones', 'branches'],
      );

      final context = tester.element(find.byType(AreaCard));
      final t = AppLocalizations.of(context);

      final addButtonFinder = find.widgetWithText(
        ElevatedButton,
        t.addObservation,
      );
      await tester.tap(addButtonFinder);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Uusi lumi'));
      await tester.pumpAndSettle();

      expect(find.text(t.specifySnowType), findsOneWidget);

      final backButtonFinder = find.widgetWithText(ElevatedButton, t.back);
      await tester.tap(backButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text(t.selectSnowType), findsOneWidget);
    });
  });
}
