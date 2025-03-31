import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/authentication/presentation/pages/get_info_profile_page.dart';

void main() {
  testWidgets('GetMoreInfoProfilePage has a pseudo field', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: GetMoreInfoProfilePage(email: '', password: '')),
      ),
    );

    final pseudoField = find.byKey(Key('pseudoField'));
    expect(pseudoField, findsOneWidget);
  });
}
