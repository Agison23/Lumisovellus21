import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';
import 'package:lumisovellus/features/map/views/widgets/area_card_form.dart';
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

Future<void> _pumpWithSelectStep(
  WidgetTester tester, {
  required List<SnowType> snowTypes,
  required ValueChanged<String> onPick,
  required VoidCallback onBack,
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
            body: AreaCardSelectCategoryStep(
              t: t,
              snowTypes: snowTypes,
              onPick: onPick,
              onBack: onBack,
            ),
          );
        },
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _pumpWithSpecifyStep(
  WidgetTester tester, {
  required String segmentId,
  required List<SnowType> allTypes,
  required String? selectedCategoryId,
  required String? selectedSnowTypeId,
  required List<String> hazards,
  required List<String> selectedHazards,
  required ValueChanged<String> onPickType,
  required ValueChanged<String> onToggleHazard,
  required VoidCallback onBack,
  required VoidCallback onSubmit,
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
            body: AreaCardSpecifyTypeStep(
              t: t,
              segmentId: segmentId,
              allTypes: allTypes,
              selectedCategoryId: selectedCategoryId,
              selectedSnowTypeId: selectedSnowTypeId,
              hazards: hazards,
              selectedHazards: selectedHazards,
              onPickType: onPickType,
              onToggleHazard: onToggleHazard,
              onBack: onBack,
              onSubmit: onSubmit,
            ),
          );
        },
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('AreaCardSelectCategoryStep', () {
    testWidgets('renders category buttons and calls callbacks', (tester) async {
      String? picked;
      bool backPressed = false;

      final snowTypes = [
        _snowType(
          id: 'korppu',
          identifier: 'korppu',
          name: 'Korppu',
          colour: '#3838a0',
          skiability: 3,
          primarySnowTypeId: null,
          explanation:
              'Kova hangen pinnalla oleva kansi. Korppu voi olla tasaista tai rosoista.',
        ),
        _snowType(
          id: 'sohjo',
          identifier: 'sohjo',
          name: 'Sohjo',
          colour: '#919394',
          skiability: 2,
          primarySnowTypeId: null,
          explanation: 'Vesipitoinen ja osittain sulanut lumi suojasäällä.',
        ),
      ];

      await _pumpWithSelectStep(
        tester,
        snowTypes: snowTypes,
        onPick: (id) => picked = id,
        onBack: () => backPressed = true,
      );

      expect(find.text('Korppu'), findsOneWidget);
      expect(find.text('Sohjo'), findsOneWidget);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Korppu'));
      await tester.pumpAndSettle();
      expect(picked, 'korppu');

      final context = tester.element(find.byType(AreaCardSelectCategoryStep));
      final t = AppLocalizations.of(context);
      final backButtonFinder = find.widgetWithText(ElevatedButton, t.back);

      await tester.tap(backButtonFinder);
      await tester.pumpAndSettle();
      expect(backPressed, true);
    });
  });

  group('AreaCardSpecifyTypeStep', () {
    testWidgets('filters options by selectedCategoryId and shows explanation', (
      tester,
    ) async {
      String? pickedType;

      final allTypes = [
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
        _snowType(
          id: 'puuterilumi',
          identifier: 'puuterilumi',
          name: 'Puuterilumi',
          colour: '#5AABED',
          skiability: 5,
          primarySnowTypeId: 'uusi_lumi',
          explanation: 'Vastasatanutta irtonaista ja höyhenenkevyttä lunta.',
        ),
        _snowType(
          id: 'korppu',
          identifier: 'korppu',
          name: 'Korppu',
          colour: '#3838a0',
          skiability: 3,
          primarySnowTypeId: null,
          explanation: 'Kova hangen pinnalla oleva kansi.',
        ),
      ];

      await _pumpWithSpecifyStep(
        tester,
        segmentId: 'seg-1',
        allTypes: allTypes,
        selectedCategoryId: 'uusi_lumi',
        selectedSnowTypeId: 'vitilumi',
        hazards: const [],
        selectedHazards: const [],
        onPickType: (id) => pickedType = id,
        onToggleHazard: (_) {},
        onBack: () {},
        onSubmit: () {},
      );

      expect(find.text('Vitilumi'), findsOneWidget);
      expect(find.text('Puuterilumi'), findsOneWidget);
      expect(find.text('Korppu'), findsNothing);
      expect(find.textContaining('kevyttä, pehmeää'), findsOneWidget);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Puuterilumi'));
      await tester.pumpAndSettle();
      expect(pickedType, 'puuterilumi');
    });

    testWidgets('shows hazard buttons and toggles via callback', (
      tester,
    ) async {
      final allTypes = [
        _snowType(
          id: 'korppu',
          identifier: 'korppu',
          name: 'Korppu',
          colour: '#3838a0',
          skiability: 3,
          primarySnowTypeId: null,
          explanation: 'Korppu pinta.',
        ),
        _snowType(
          id: 'ohut_korppu',
          identifier: 'ohut_korppu',
          name: 'Ohut korppu',
          colour: '#3838a0',
          skiability: 3,
          primarySnowTypeId: 'korppu',
          explanation: 'Hiihtäjän painosta rikkoutuva lumikansi.',
        ),
      ];

      final hazards = ['stones', 'branches'];
      final selectedHazards = <String>[];
      String? lastToggled;

      await _pumpWithSpecifyStep(
        tester,
        segmentId: 'seg-1',
        allTypes: allTypes,
        selectedCategoryId: 'korppu',
        selectedSnowTypeId: 'ohut_korppu',
        hazards: hazards,
        selectedHazards: selectedHazards,
        onPickType: (_) {},
        onToggleHazard: (h) => lastToggled = h,
        onBack: () {},
        onSubmit: () {},
      );

      expect(find.text('Stones'), findsOneWidget);
      expect(find.text('Branches'), findsOneWidget);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Stones'));
      await tester.pumpAndSettle();
      expect(lastToggled, 'stones');
    });

    testWidgets('submit button disabled without selected type, enabled with', (
      tester,
    ) async {
      final allTypes = [
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
          explanation: 'Vitilumi kuvaus.',
        ),
      ];

      bool submitted = false;

      await _pumpWithSpecifyStep(
        tester,
        segmentId: 'seg-1',
        allTypes: allTypes,
        selectedCategoryId: 'uusi_lumi',
        selectedSnowTypeId: null,
        hazards: const [],
        selectedHazards: const [],
        onPickType: (_) {},
        onToggleHazard: (_) {},
        onBack: () {},
        onSubmit: () => submitted = true,
      );

      final context = tester.element(find.byType(AreaCardSpecifyTypeStep));
      final t = AppLocalizations.of(context);
      final submitButtonFinder = find.widgetWithText(ElevatedButton, t.submit);

      final submitButton1 = tester.widget<ElevatedButton>(submitButtonFinder);
      expect(submitButton1.onPressed, isNull);

      await _pumpWithSpecifyStep(
        tester,
        segmentId: 'seg-1',
        allTypes: allTypes,
        selectedCategoryId: 'uusi_lumi',
        selectedSnowTypeId: 'vitilumi',
        hazards: const [],
        selectedHazards: const [],
        onPickType: (_) {},
        onToggleHazard: (_) {},
        onBack: () {},
        onSubmit: () => submitted = true,
      );

      final submitButton2 = tester.widget<ElevatedButton>(submitButtonFinder);
      expect(submitButton2.onPressed, isNotNull);

      await tester.tap(submitButtonFinder);
      await tester.pumpAndSettle();
      expect(submitted, true);
    });
  });
}
