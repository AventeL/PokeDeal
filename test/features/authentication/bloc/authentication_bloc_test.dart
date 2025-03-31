import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/authentication/presentation/bloc/authentication_bloc.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  late AuthenticationRepository authenticationRepository;
  late AuthenticationBloc authenticationBloc;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
    authenticationBloc = AuthenticationBloc(
      authenticationRepository: authenticationRepository,
    );
  });

  tearDown(() {
    authenticationBloc.close();
  });

  UserProfile mockUser = UserProfile(
    id: '1',
    email: 'test@gmail.com',
    pseudo: 'test',
    createdAt: DateTime.now(),
  );

  group('AuthenticationBloc Login with email', () {
    void mockSignInWithEmail() {
      when(
        authenticationRepository.signInWithEmail('test@gmail.com', '123456'),
      ).thenAnswer((_) async => mockUser);
    }

    void mockSignInWithEmailFail() {
      when(
        authenticationRepository.signInWithEmail('test@gmail.com', '123456'),
      ).thenThrow(Exception('Failed to sign in'));
    }

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [AuthenticationLoading, AuthenticationAuthenticated] when successful',
      build: () {
        mockSignInWithEmail();
        return authenticationBloc;
      },
      act: (bloc) {
        bloc.add(
          AuthenticationEventSignInWithEmail('test@gmail.com', '123456'),
        );
      },
      expect:
          () => [AuthenticationLoading(), isA<AuthenticationAuthenticated>()],
      verify: (bloc) {
        verify(
          authenticationRepository.signInWithEmail('test@gmail.com', '123456'),
        ).called(1);
        expect(
          (bloc.state as AuthenticationAuthenticated).userProfile,
          mockUser,
        );
      },
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [AuthenticationLoading, AuthenticationError] when unsuccessful',
      build: () {
        mockSignInWithEmailFail();
        return authenticationBloc;
      },
      act: (bloc) {
        bloc.add(
          AuthenticationEventSignInWithEmail('test@gmail.com', '123456'),
        );
      },
      expect: () => [AuthenticationLoading(), isA<AuthenticationError>()],
      verify: (bloc) {
        verify(
          authenticationRepository.signInWithEmail('test@gmail.com', '123456'),
        ).called(1);
        expect(
          (bloc.state as AuthenticationError).message,
          Exception('Failed to sign in').toString(),
        );
      },
    );
  });

  group('AuthenticationBloc Sign up with email', () {
    void mockSignUpWithEmail() {
      when(
        authenticationRepository.signUpWithEmail(
          'test@gmail.com',
          '123456',
          'test',
        ),
      ).thenAnswer((_) async => mockUser);
    }

    void mockSignUpWithEmailFail() {
      when(
        authenticationRepository.signUpWithEmail(
          'test@gmail.com',
          '123456',
          'test',
        ),
      ).thenThrow(Exception('Failed to sign up'));
    }

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [AuthenticationLoading, AuthenticationAuthenticated] when successful',
      build: () {
        mockSignUpWithEmail();
        return authenticationBloc;
      },
      act: (bloc) {
        bloc.add(
          AuthenticationEventSignUpWithEmail(
            'test@gmail.com',
            '123456',
            'test',
          ),
        );
      },
      expect:
          () => [AuthenticationLoading(), isA<AuthenticationAuthenticated>()],
      verify: (bloc) {
        verify(
          authenticationRepository.signUpWithEmail(
            'test@gmail.com',
            '123456',
            'test',
          ),
        ).called(1);
        expect(
          (bloc.state as AuthenticationAuthenticated).userProfile,
          mockUser,
        );
      },
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [AuthenticationLoading, AuthenticationError] when unsuccessful',
      build: () {
        mockSignUpWithEmailFail();
        return authenticationBloc;
      },
      act: (bloc) {
        bloc.add(
          AuthenticationEventSignUpWithEmail(
            'test@gmail.com',
            '123456',
            'test',
          ),
        );
      },
      expect: () => [AuthenticationLoading(), isA<AuthenticationError>()],
      verify: (bloc) {
        verify(
          authenticationRepository.signUpWithEmail(
            'test@gmail.com',
            '123456',
            'test',
          ),
        ).called(1);
        expect(
          (bloc.state as AuthenticationError).message,
          Exception('Failed to sign up').toString(),
        );
      },
    );
  });

  group('AuthenticationBloc Sign out', () {
    void mockSignOut() {
      when(authenticationRepository.signOut()).thenAnswer((_) async => true);
    }

    void mockSignOutFail() {
      when(
        authenticationRepository.signOut(),
      ).thenThrow(Exception('Failed to sign out'));
    }

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [AuthenticationLoading, AuthenticationUnauthenticated] when successful',
      build: () {
        mockSignOut();
        return authenticationBloc;
      },
      act: (bloc) {
        bloc.add(AuthenticationEventSignOut());
      },
      expect:
          () => [AuthenticationLoading(), isA<AuthenticationUnauthenticated>()],
      verify: (bloc) {
        verify(authenticationRepository.signOut()).called(1);
      },
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [AuthenticationLoading, AuthenticationError] when unsuccessful',
      build: () {
        mockSignOutFail();
        return authenticationBloc;
      },
      act: (bloc) {
        bloc.add(AuthenticationEventSignOut());
      },
      expect: () => [AuthenticationLoading(), isA<AuthenticationError>()],
      verify: (bloc) {
        verify(authenticationRepository.signOut()).called(1);
        expect(
          (bloc.state as AuthenticationError).message,
          Exception('Failed to sign out').toString(),
        );
      },
    );
  });
}
