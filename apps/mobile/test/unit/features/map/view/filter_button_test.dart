import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';
import 'package:lumisovellus/features/map/views/widgets/filter_button.dart';
import 'package:lumisovellus/features/map/providers.dart';

class FakeAreasLayerManager extends AreasLayerManager {
  bool? lastVisible;

  @override
  Future<void> setAreasVisible(bool visible) async {
    lastVisible = visible;
  }
}

Future<FakeAreasLayerManager> _pumpFilterButton(WidgetTester tester) async {
  final fakeManager = FakeAreasLayerManager();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [areasLayerManagerProvider.overrideWithValue(fakeManager)],
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
              body: Center(child: FilterButton(t: t)),
            );
          },
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();
  return fakeManager;
}

void main() {
  testWidgets('renders filter icon button', (tester) async {
    await _pumpFilterButton(tester);

    expect(find.byIcon(Icons.filter_list), findsOneWidget);
  });

  testWidgets('opens popup with segments and sensors options', (tester) async {
    await _pumpFilterButton(tester);

    final context = tester.element(find.byType(FilterButton));
    final t = AppLocalizations.of(context);

    await tester.tap(find.byType(FilterButton));
    await tester.pumpAndSettle();

    expect(find.text(t.segments), findsOneWidget);
    expect(find.text(t.sensors), findsOneWidget);
  });

  testWidgets('tapping segments toggles visibility via areas manager', (
    tester,
  ) async {
    final fakeManager = await _pumpFilterButton(tester);

    final context = tester.element(find.byType(FilterButton));
    final t = AppLocalizations.of(context);

    await tester.tap(find.byType(FilterButton));
    await tester.pumpAndSettle();

    final segmentsText = find.text(t.segments);
    await tester.tap(segmentsText);
    await tester.pumpAndSettle();

    expect(fakeManager.lastVisible, isFalse);

    await tester.tap(find.byType(FilterButton));
    await tester.pumpAndSettle();

    await tester.tap(segmentsText);
    await tester.pumpAndSettle();

    expect(fakeManager.lastVisible, isTrue);
  });
}
