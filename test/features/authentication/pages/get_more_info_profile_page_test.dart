import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:pokedeal/features/authentication/presentation/pages/get_info_profile_page.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  testWidgets('GetMoreInfoProfilePage has a pseudo field', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create:
              (context) => AuthenticationBloc(
                authenticationRepository: MockAuthenticationRepository(),
              ),
          child: GetMoreInfoProfilePage(email: '', password: ''),
        ),
      ),
    );

    final pseudoField = find.byKey(Key('pseudoField'));
    expect(pseudoField, findsOneWidget);

    final continueButton = find.byKey(Key('continueButton'));
    expect(continueButton, findsOneWidget);
  });
}
