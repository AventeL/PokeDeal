import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/features/authentication/data/authentication_data_source_interface.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  late IAuthenticationDataSource dataSource;
  late AuthenticationRepository repository;

  setUp(() {
    dataSource = MockIAuthenticationDataSource();
    repository = AuthenticationRepository(authenticationDataSource: dataSource);
  });

  UserProfile mockUser = UserProfile(
    id: '1',
    email: 'test@gmail.com',
    pseudo: 'test',
    createdAt: DateTime.now(),
  );

  group('signInWithEmail', () {
    test('signInWithEmail returns AuthResponse on success', () async {
      when(
        dataSource.signInWithEmail('test@gmail.com', '123456'),
      ).thenAnswer((_) async => mockUser);

      final response = await repository.signInWithEmail(
        'test@gmail.com',
        '123456',
      );

      expect(response, mockUser);
      verify(dataSource.signInWithEmail('test@gmail.com', '123456')).called(1);
    });

    test('signInWithEmail throws an exception on failure', () async {
      when(
        dataSource.signInWithEmail('test@gmail.com', '123456'),
      ).thenThrow(Exception('Failed to sign in'));

      expect(
        () async =>
            await repository.signInWithEmail('test@gmail.com', '123456'),
        throwsA(
          predicate(
            (e) =>
                e is Exception &&
                e.toString() == Exception('Failed to sign in').toString(),
          ),
        ),
      );

      verify(dataSource.signInWithEmail('test@gmail.com', '123456')).called(1);
    });
  });

  group('signUpWithEmail', () {
    test('signUpWithEmail returns AuthResponse on success', () async {
      when(
        dataSource.signUpWithEmail('test@gmail.com', '123456', 'test'),
      ).thenAnswer((_) async => mockUser);

      final response = await repository.signUpWithEmail(
        'test@gmail.com',
        '123456',
        'test',
      );

      expect(response, mockUser);
      verify(
        dataSource.signUpWithEmail('test@gmail.com', '123456', 'test'),
      ).called(1);
    });

    test('signUpWithEmail throws an exception on failure', () async {
      when(
        dataSource.signUpWithEmail('test@gmail.com', '123456', 'test'),
      ).thenThrow(Exception('Failed to sign up'));

      expect(
        () async => await repository.signUpWithEmail(
          'test@gmail.com',
          '123456',
          'test',
        ),
        throwsA(
          predicate(
            (e) =>
                e is Exception &&
                e.toString() == Exception('Failed to sign up').toString(),
          ),
        ),
      );

      verify(
        dataSource.signUpWithEmail('test@gmail.com', '123456', 'test'),
      ).called(1);
    });
  });

  group('getUserProfile', () {
    test('getUserProfile returns UserProfile on success', () async {
      when(dataSource.getUserProfile()).thenAnswer((_) async => mockUser);

      final response = await repository.getUserProfile();

      expect(response, mockUser);
      verify(dataSource.getUserProfile()).called(1);
    });

    test('getUserProfile returns cached UserProfile if it exists', () async {
      repository.userProfile = mockUser;

      final response = await repository.getUserProfile();

      expect(response, mockUser);
      verifyNever(dataSource.getUserProfile());
    });

    test('getUserProfile throws an exception on failure', () async {
      when(
        dataSource.getUserProfile(),
      ).thenThrow(Exception('Failed to get user profile'));

      expect(
        () async => await repository.getUserProfile(),
        throwsA(
          predicate(
            (e) =>
                e is Exception &&
                e.toString() ==
                    Exception('Failed to get user profile').toString(),
          ),
        ),
      );

      verify(dataSource.getUserProfile()).called(1);
    });
  });

  group('signOut', () {
    test('signOut calls signOut on dataSource', () async {
      await repository.signOut();

      verify(dataSource.signOut()).called(1);
    });

    test('signOut throws an exception on failure', () async {
      when(dataSource.signOut()).thenThrow(Exception('Failed to sign out'));

      expect(
        () async => await repository.signOut(),
        throwsA(
          predicate(
            (e) =>
                e is Exception &&
                e.toString() == Exception('Failed to sign out').toString(),
          ),
        ),
      );

      verify(dataSource.signOut()).called(1);
    });
  });
}
