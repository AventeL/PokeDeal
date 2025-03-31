// This is a basic Flutter widgets test.
//
// To perform an interaction with a widgets in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widgets
// tree, read text, and verify that the values of widgets properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/home/presentation/widgets/custom_bottom_navigation_bar.dart';

void main() {
  testWidgets('CustomBottomNavigationBar displays correct items', (WidgetTester tester) async {
    // 1. Chargez le widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: CustomBottomNavigationBar(),
        ),
      ),
    );

    // 2. Vérifiez que le BottomNavigationBar est bien affiché
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // 3. Vérifiez la présence des icônes
    expect(find.byIcon(Icons.compare_arrows), findsOneWidget); // Icône "Echanges"
    expect(find.byIcon(Icons.book), findsOneWidget); // Icône "Collection"
    expect(find.byIcon(Icons.person), findsOneWidget); // Icône "Profil"

    // 4. Vérifiez la présence des labels
    expect(find.text('Echanges'), findsOneWidget);
    expect(find.text('Collection'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
  });
}