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
  testWidgets('CustomBottomNavigationBar displays correct items', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: 1,
            onTap: (index) {},
          ),
        ),
      ),
    );

    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Icônes
    expect(find.byIcon(Icons.compare_arrows), findsOneWidget);
    expect(find.byIcon(Icons.book), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);

    // 4. Vérifiez la présence des labels
    expect(find.text('Echanges'), findsOneWidget);
    expect(find.text('Collection'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
  });
}
