import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/bottom_bar/bottomBar.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/state/appState.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/side_bar/navigation_drawer.dart';

void main() {
  testWidgets('Test language dropdown menu', (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [ChangeNotifierProvider<AppState>(create: (_) => AppState())],
      child: const MaterialApp(
        home: Scaffold(
          drawer: MyNavigationDrawer(),
        ),
      ),
    ));
    await tester.dragFrom(
        tester.getTopLeft(find.byType(MaterialApp)), Offset(300, 0));
    await tester.pumpAndSettle();

    expect(find.text('SUOMI'), findsOneWidget);
    expect(find.text('ENGLISH'), findsOneWidget);
  });
}
