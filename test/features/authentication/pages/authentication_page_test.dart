import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:pokedeal/features/authentication/presentation/pages/authentication_page.dart';
import 'package:pokedeal/features/authentication/presentation/pages/login_page_view.dart';
import 'package:pokedeal/features/authentication/presentation/pages/register_page_view.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  testWidgets('AuthenticationPage has a TabBar with Login and Register tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider(
            create:
                (_) => AuthenticationBloc(
                  authenticationRepository: MockAuthenticationRepository(),
                ),
            child: AuthenticationPage(),
          ),
        ),
      ),
    );

    expect(find.widgetWithText(Tab, 'Connexion'), findsOneWidget);
    expect(find.widgetWithText(Tab, 'Inscription'), findsOneWidget);

    await tester.tap(find.widgetWithText(Tab, 'Inscription'));
    await tester.pumpAndSettle();
    expect(find.byType(RegisterPageView), findsOneWidget);
    final button = find.widgetWithText(ElevatedButton, "S'inscrire");
    expect(button, findsOneWidget);

    await tester.tap(find.widgetWithText(Tab, 'Connexion'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginPageView), findsOneWidget);
    final button2 = find.widgetWithText(ElevatedButton, "Se connecter");
    expect(button2, findsOneWidget);
  });
}
