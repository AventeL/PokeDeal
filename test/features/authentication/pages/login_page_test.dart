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

    final passwordVisibilityButton = find.byKey(
      Key('passwordVisibilityButton'),
    );
    expect(passwordVisibilityButton, findsOneWidget);
    Icon icon = tester.widget<Icon>(
      find.descendant(
        of: passwordVisibilityButton,
        matching: find.byType(Icon),
      ),
    );
    expect(icon.icon, Icons.visibility);

    await tester.tap(passwordVisibilityButton);
    await tester.pump();

    icon = tester.widget<Icon>(
      find.descendant(
        of: passwordVisibilityButton,
        matching: find.byType(Icon),
      ),
    );
    expect(icon.icon, Icons.visibility_off);

    await tester.tap(passwordVisibilityButton);
    await tester.pump();

    icon = tester.widget<Icon>(
      find.descendant(
        of: passwordVisibilityButton,
        matching: find.byType(Icon),
      ),
    );
    expect(icon.icon, Icons.visibility);
  });
}
