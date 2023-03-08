import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/bottom_bar/bottomBar.dart';
import 'package:mobile_app/state/appState.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Show Rescue dialog onTap', (tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [ChangeNotifierProvider<AppState>(create: (_) => AppState())],
      child: const MaterialApp(
        home: Scaffold(
          bottomNavigationBar: BottomBar(),
        ),
      ),
    ));
    await tester.tap(find.text('Pyydä\napua'));
    await tester.pumpAndSettle();

    expect(find.text('Millaista apua tarvitset?'), findsOneWidget);
  });

  testWidgets('Show Sharing Location dialog onTap', (tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [ChangeNotifierProvider<AppState>(create: (_) => AppState())],
      child: const MaterialApp(
        home: Scaffold(
          bottomNavigationBar: BottomBar(),
        ),
      ),
    ));
    await tester.tap(find.text('Sijainti'));
    await tester.pumpAndSettle();

    expect(find.text('Sijaintitiedon jakaminen'), findsOneWidget);
  });
}
