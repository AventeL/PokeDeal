import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/authentication/presentation/pages/login_page_view.dart';

void main() {
  testWidgets('Login page has email and password TextFields and a button', (
    WidgetTester tester,
  ) async {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoginPageView(
            emailController: emailController,
            passwordController: passwordController,
          ),
        ),
      ),
    );

    final emailField = find.byKey(Key('emailField'));
    expect(emailField, findsOneWidget);

    final passwordField = find.byKey(Key('passwordField'));
    expect(passwordField, findsOneWidget);
  });
}
