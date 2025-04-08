import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/profile/data/profile_data_source_interface.dart';
import 'package:pokedeal/features/profile/domain/repository/profile_repository.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  late IProfileDataSource dataSource;
  late ProfileRepository profileRepository;
  late AuthenticationRepository authenticationRepository;

  setUp(() {
    final getIt = GetIt.instance;
    getIt.reset();

    final mockAuthenticationRepository = MockAuthenticationRepository();
    final mockDataSource = MockIProfileDataSource();

    getIt.registerLazySingleton<AuthenticationRepository>(
      () => mockAuthenticationRepository,
    );
    getIt.registerLazySingleton<IProfileDataSource>(() => mockDataSource);

    authenticationRepository = getIt<AuthenticationRepository>();
    dataSource = getIt<IProfileDataSource>();
    profileRepository = ProfileRepository(profileDataSource: dataSource);
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  UserProfile mockUserProfile = UserProfile(
    id: "id",
    email: "email",
    pseudo: "pseudo",
    createdAt: DateTime.now(),
  );

  group('getProfile', () {
    test(
      'getProfile returns a profile and calls authenticationRepository if there is a currentUser',
      () async {
        when(
          authenticationRepository.getUserProfile(),
        ).thenAnswer((_) async => mockUserProfile);

        when(authenticationRepository.userProfile).thenReturn(mockUserProfile);

        when(dataSource.getProfile(id: mockUserProfile.id));

        when(
          dataSource.getProfile(id: mockUserProfile.id),
        ).thenAnswer((_) async => mockUserProfile);

        final result = await profileRepository.getProfile(
          id: mockUserProfile.id,
        );

        expect(result, isA<UserProfile>());
        expect(result, mockUserProfile);

        verify(authenticationRepository.getUserProfile()).called(1);
      },
    );

    test(
      'getProfile returns a profile and calls dataSource if there is no currentUser',
      () async {
        when(
          dataSource.getProfile(id: mockUserProfile.id),
        ).thenAnswer((_) async => mockUserProfile); // 🔹 Ajout du stub correct

        authenticationRepository.userProfile = null;

        final result = await profileRepository.getProfile(
          id: mockUserProfile.id,
        );

        expect(result, isA<UserProfile>());
        expect(result, mockUserProfile);
        verify(dataSource.getProfile(id: mockUserProfile.id)).called(1);
      },
    );
  });
}
