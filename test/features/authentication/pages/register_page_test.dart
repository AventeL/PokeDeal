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

      final confirmPasswordVisibilityButton = find.byKey(
        Key('passwordVisibilityButton'),
      );
      expect(passwordVisibilityButton, findsOneWidget);
      Icon icon2 = tester.widget<Icon>(
        find.descendant(
          of: confirmPasswordVisibilityButton,
          matching: find.byType(Icon),
        ),
      );
      expect(icon2.icon, Icons.visibility);

      await tester.tap(confirmPasswordVisibilityButton);
      await tester.pump();

      icon2 = tester.widget<Icon>(
        find.descendant(
          of: confirmPasswordVisibilityButton,
          matching: find.byType(Icon),
        ),
      );
      expect(icon2.icon, Icons.visibility_off);

      await tester.tap(confirmPasswordVisibilityButton);
      await tester.pump();

      icon2 = tester.widget<Icon>(
        find.descendant(
          of: confirmPasswordVisibilityButton,
          matching: find.byType(Icon),
        ),
      );
      expect(icon2.icon, Icons.visibility);
    },
  );
}
