import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/bottom_bar/bottomBar.dart';

void main() {
  testWidgets(
      'Show Rescue dialog onTap',
          (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomBar(),
          ),
        ));
        await tester.tap(find.text('Pyydäapua'));
        await tester.pumpAndSettle();

        expect(find.text('Millaista apua tarvitset?'), findsOneWidget);
      });

  testWidgets(
      'Show Sharing Location dialog onTap',
          (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomBar(),
          ),
        ));
        await tester.tap(find.byIcon(Icons.near_me_rounded));
        await tester.pumpAndSettle();

        expect(find.text('Sijaintitiedon jakaminen'), findsOneWidget);
      });
}