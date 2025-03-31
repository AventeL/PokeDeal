import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/Authentication/presentation/pages/login_page_view.dart';

void main() {
  testWidgets('Login page has email and password TextFields and a button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginPageView())));

    final emailField = find.byKey(Key('emailField'));
    expect(emailField, findsOneWidget);

    final passwordField = find.byKey(Key('passwordField'));
    expect(passwordField, findsOneWidget);

    final loginButton = find.byKey(Key('loginButton'));
    expect(loginButton, findsOneWidget);
  });
}
