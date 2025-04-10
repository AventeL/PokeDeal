import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:pokedeal/features/profile/presentation/pages/settings_page.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  Widget createSettingsPage() {
    return MaterialApp(
      home: BlocProvider(
        create:
            (context) => AuthenticationBloc(
              authenticationRepository: MockAuthenticationRepository(),
            ),
        child: const SettingsPage(),
      ),
    );
  }

  testWidgets('Settings page has a disconnect button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createSettingsPage());

    expect(find.text('Déconnexion'), findsOneWidget);
  });
}
