import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/authentication/presentation/pages/register_page_view.dart';

void main() {
  testWidgets(
    'Register page has email, password and confirm password TextFields and a button',
    (WidgetTester tester) async {
      final emailController = TextEditingController();
      final passwordController = TextEditingController();
      final confirmPasswordController = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RegisterPageView(
              emailController: emailController,
              passwordController: passwordController,
              confirmPasswordController: confirmPasswordController,
            ),
          ),
        ),
      );

      final emailField = find.byKey(Key('emailField'));
      expect(emailField, findsOneWidget);

      final passwordField = find.byKey(Key('passwordField'));
      expect(passwordField, findsOneWidget);

      final confirmPasswordField = find.byKey(Key('confirmPasswordField'));
      expect(confirmPasswordField, findsOneWidget);
    },
  );
}
