import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/profile/domain/model/user_profile_with_stats.dart';
import 'package:pokedeal/features/profile/domain/repository/profile_repository.dart';
import 'package:pokedeal/features/profile/presentation/bloc/profile_bloc.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  late ProfileBloc profileBloc;
  late ProfileRepository profileRepository;

  setUp(() {
    profileRepository = MockProfileRepository();
    profileBloc = ProfileBloc(profileRepository: profileRepository);
  });

  tearDown(() {
    profileBloc.close();
  });

  final mockUserProfile = UserProfile(
    id: 'id',
    email: 'email',
    createdAt: DateTime.now(),
    pseudo: 'name',
  );

  final mockUserProfileWithStats = UserProfileWithStats(
    user: mockUserProfile,
    nbcards: 10,
    nbexchange: 1,
    nbseries: 2,
  );

  group('onProfileLoadEvent', () {
    void mockGetProfile() {
      when(
        profileRepository.getProfileWithStats(id: 'id'),
      ).thenAnswer((_) async => mockUserProfileWithStats);
    }

    void mockGetProfileFail() {
      when(
        profileRepository.getProfileWithStats(id: 'id'),
      ).thenThrow(Exception('Failed to get profile'));
    }

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileLoaded] when onProfileLoadEvent is added and succeeds',
      build: () {
        mockGetProfile();
        return profileBloc;
      },
      act: (bloc) => bloc.add(ProfileLoadEvent(userId: 'id')),
      expect:
          () => [
            ProfileLoading(),
            ProfileLoaded(userProfile: mockUserProfileWithStats),
          ],
      verify: (_) {
        verify(profileRepository.getProfileWithStats(id: 'id')).called(1);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileError] when onProfileLoadEvent is added and fails',
      build: () {
        mockGetProfileFail();
        return profileBloc;
      },
      act: (bloc) => bloc.add(ProfileLoadEvent(userId: 'id')),
      expect:
          () => [
            ProfileLoading(),
            isA<ProfileError>().having(
              (e) => e.message,
              'message',
              Exception('Failed to get profile').toString(),
            ),
          ],
      verify: (_) {
        verify(profileRepository.getProfileWithStats(id: 'id')).called(1);
      },
    );
  });
  group('onProfileUpdateEvent', () {
    void mockUpdateProfile() {
      when(
        profileRepository.updateProfile(
          user: mockUserProfile,
          password: 'password',
          currentUser: mockUserProfile,
        ),
      ).thenAnswer((_) async => Future.value());
    }

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileUpdated] when profile update is successful',
      build: () {
        mockUpdateProfile();
        return profileBloc;
      },
      act: (bloc) {
        bloc.add(
          ProfileUpdateEvent(
            user: mockUserProfile,
            password: 'password',
            currentUser: UserProfile(
              id: mockUserProfile.id,
              email: 'test987465@gmail.com',
              pseudo: 'test',
              createdAt: mockUserProfile.createdAt,
            ),
          ),
        );
      },
      expect:
          () => [
            ProfileLoading(),
            ProfileUpdated(userProfile: mockUserProfile),
          ],
      verify: (_) {
        verify(
          profileRepository.updateProfile(
            user: mockUserProfile,
            password: 'password',
            currentUser: UserProfile(
              id: mockUserProfile.id,
              email: 'test987465@gmail.com',
              pseudo: 'test',
              createdAt: mockUserProfile.createdAt,
            ),
          ),
        ).called(1);
      },
    );
  });
  group('onProfileChangePasswordEvent', () {
    void mockChangePassword() {
      when(
        profileRepository.changePassword(
          currentPassword: 'currentPassword',
          newPassword: 'newPassword',
          email: 'email',
        ),
      ).thenAnswer((_) async => Future.value());
    }

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileUpdated] when password change is successful',
      build: () {
        mockChangePassword();
        return profileBloc;
      },
      act: (bloc) {
        bloc.add(
          ChangePasswordEvent(
            currentPassword: 'currentPassword',
            newPassword: 'newPassword',
            email: 'email',
          ),
        );
      },
      expect: () => [ProfileLoading(), ChangePasswordSuccess()],
      verify: (_) {
        verify(
          profileRepository.changePassword(
            currentPassword: 'currentPassword',
            newPassword: 'newPassword',
            email: 'email',
          ),
        ).called(1);
      },
    );
  });
}
