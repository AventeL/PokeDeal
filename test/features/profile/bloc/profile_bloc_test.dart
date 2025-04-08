import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
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

  group('onProfileLoadEvent', () {
    void mockGetProfile() {
      when(
        profileRepository.getProfile(id: 'id'),
      ).thenAnswer((_) async => mockUserProfile);
    }

    void mockGetProfileFail() {
      when(
        profileRepository.getProfile(id: 'id'),
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
          () => [ProfileLoading(), ProfileLoaded(userProfile: mockUserProfile)],
      verify: (_) {
        verify(profileRepository.getProfile(id: 'id')).called(1);
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
        verify(profileRepository.getProfile(id: 'id')).called(1);
      },
    );
  });
}
