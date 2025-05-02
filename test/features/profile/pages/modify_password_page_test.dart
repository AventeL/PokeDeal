import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:pokedeal/features/profile/presentation/pages/modify_password_page.dart';

class MockProfileBloc extends Mock implements ProfileBloc {}

void main() {
  late MockProfileBloc mockProfileBloc;

  setUp(() {
    mockProfileBloc = MockProfileBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<ProfileBloc>.value(
        value: mockProfileBloc,
        child: const ModifyPasswordPage(),
      ),
    );
  }

  testWidgets('print textfield in modify password page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Ancien mot de passe'), findsNWidgets(2));
    expect(find.text('Nouveau mot de passe'), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
