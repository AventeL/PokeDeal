import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/features/authentication/data/authentication_data_source_interface.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  late IAuthenticationDataSource dataSource;
  late AuthenticationRepository repository;

  setUp(() {
    dataSource = MockIAuthenticationDataSource();
    repository = AuthenticationRepository(authenticationDataSource: dataSource);
  });

  final mockUser = User(
    id: 'test_id',
    appMetadata: {},
    userMetadata: {},
    aud: 'mockAud',
    createdAt: DateTime.now().toIso8601String(),
  );

  final mockSession = Session(
    accessToken: 'mockAccessToken',
    tokenType: 'mockTokenType',
    user: mockUser,
  );

  group('signInWithEmail', () {
    test('signInWithEmail returns AuthResponse on success', () async {
      when(dataSource.signInWithEmail('test@gmail.com', '123456')).thenAnswer(
        (_) async => AuthResponse(session: mockSession, user: mockUser),
      );

      final response = await repository.signInWithEmail(
        'test@gmail.com',
        '123456',
      );

      expect(response.session, mockSession);
      expect(response.user, mockUser);
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
      when(dataSource.signUpWithEmail('test@gmail.com', '123456')).thenAnswer(
        (_) async => AuthResponse(session: mockSession, user: mockUser),
      );

      final response = await repository.signUpWithEmail(
        'test@gmail.com',
        '123456',
      );

      expect(response.session, mockSession);
      expect(response.user, mockUser);
      verify(dataSource.signUpWithEmail('test@gmail.com', '123456')).called(1);
    });

    test('signUpWithEmail throws an exception on failure', () async {
      when(
        dataSource.signUpWithEmail('test@gmail.com', '123456'),
      ).thenThrow(Exception('Failed to sign up'));

      expect(
        () async =>
            await repository.signUpWithEmail('test@gmail.com', '123456'),
        throwsA(
          predicate(
            (e) =>
                e is Exception &&
                e.toString() == Exception('Failed to sign up').toString(),
          ),
        ),
      );

      verify(dataSource.signUpWithEmail('test@gmail.com', '123456')).called(1);
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
