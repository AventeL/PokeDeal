import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/collection/presentation/bloc/user_collection/user_collection_bloc.dart';
import 'package:pokedeal/features/profile/domain/model/user_profile_with_stats.dart';
import 'package:pokedeal/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:pokedeal/features/profile/presentation/pages/profile_page.dart';
import 'package:pokedeal/shared/widgets/custom_large_button.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  MockProfileBloc mockProfileBloc = MockProfileBloc();
  MockAuthenticationRepository mockAuthenticationRepository =
      MockAuthenticationRepository();
  MockUserCollectionBloc mockUserCollectionBloc = MockUserCollectionBloc();

  setUp(() {
    getIt.registerLazySingleton<AuthenticationRepository>(
      () => mockAuthenticationRepository,
    );

    when(mockAuthenticationRepository.userProfile).thenReturn(
      UserProfile(
        id: '1',
        pseudo: 'TestUser',
        createdAt: DateTime(2023, 10, 9),
        email: 'mail',
      ),
    );
  });

  tearDown(() {
    getIt.reset();
  });

  testWidgets('loading when state is ProfileLoading', (
    WidgetTester tester,
  ) async {
    when(mockProfileBloc.state).thenReturn(ProfileLoading());

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
            BlocProvider<UserCollectionBloc>.value(
              value: mockUserCollectionBloc,
            ),
          ],
          child: const ProfilePage(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('display Profile infos when state is ProfileLoaded', (
    WidgetTester tester,
  ) async {
    final userProfile = UserProfile(
      id: '1',
      pseudo: 'TestUser',
      createdAt: DateTime(2023, 10, 9),
      email: 'mail',
    );

    final userProfileWithStats = UserProfileWithStats(
      user: userProfile,
      nbcards: 10,
      nbexchange: 1,
      nbseries: 2,
    );

    when(
      mockProfileBloc.state,
    ).thenReturn(ProfileLoaded(userProfile: userProfileWithStats));

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
            BlocProvider<UserCollectionBloc>.value(
              value: mockUserCollectionBloc,
            ),
          ],
          child: const ProfilePage(),
        ),
      ),
    );

    expect(find.text('TestUser'), findsOneWidget);
    expect(find.text('Cartes'), findsOneWidget);
    expect(find.text('Echanges'), findsOneWidget);
    expect(find.text('Séries'), findsOneWidget);
    expect(find.byType(CustomLargeButton), findsOneWidget);
    expect(find.text('Membre depuis le 09/10/2023'), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.byType(Row), findsOneWidget);
  });

  testWidgets('display error on ProfileErrorState', (
    WidgetTester tester,
  ) async {
    when(
      mockProfileBloc.state,
    ).thenReturn(ProfileError(message: 'Erreur de chargement'));
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
            BlocProvider<UserCollectionBloc>.value(
              value: mockUserCollectionBloc,
            ),
          ],
          child: const ProfilePage(),
        ),
      ),
    );

    expect(find.text('Error: Erreur de chargement'), findsOneWidget);
  });

  testWidgets('display error on InitialState', (WidgetTester tester) async {
    when(mockProfileBloc.state).thenReturn(ProfileInitial());
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
            BlocProvider<UserCollectionBloc>.value(
              value: mockUserCollectionBloc,
            ),
          ],
          child: const ProfilePage(),
        ),
      ),
    );

    expect(find.text('Impossible d\'accéder au profil'), findsOneWidget);
  });
}
