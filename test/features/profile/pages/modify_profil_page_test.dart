import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:pokedeal/features/profile/presentation/pages/modify_profile_page.dart';
import 'package:pokedeal/shared/widgets/custom_large_button.dart';

import '../../../mocks/generated_mocks.mocks.dart';

class MockProfileBloc extends Mock implements ProfileBloc {}

void main() {
  late MockProfileBloc mockProfileBloc;
  late MockAuthenticationRepository mockAuthenticationRepository;
  final getIt = GetIt.instance;
  getIt.reset();

  setUpAll(() {
    mockProfileBloc = MockProfileBloc();
    mockAuthenticationRepository = MockAuthenticationRepository();
    getIt.registerSingleton<AuthenticationRepository>(
      mockAuthenticationRepository,
    );
  });

  Widget createWidgetUnderTest() {
    when(mockAuthenticationRepository.userProfile).thenReturn(
      UserProfile(
        id: 'mock_id',
        email: 'test@example.com',
        pseudo: 'MockUser',
        createdAt: DateTime.now(),
      ),
    );
    return MaterialApp(
      home: BlocProvider<ProfileBloc>.value(
        value: mockProfileBloc,
        child: const ModifyProfilePage(),
      ),
    );
  }

  testWidgets('affiche les champs de modification de profil', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();
    expect(find.text('Pseudo'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Mot de passe'), findsNWidgets(2));
    expect(find.byType(CustomLargeButton), findsNWidgets(2));
  });
}
