import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationRepository;

  AuthenticationBloc({required this.authenticationRepository})
    : super(AuthenticationInitial()) {
    on<AuthenticationEventSignInWithEmail>(
      _onAuthenticationEventSignInWithEmail,
    );
    on<AuthenticationEventSignUpWithEmail>(
      _onAuthenticationEventSignUpWithEmail,
    );
    on<AuthenticationEventSignOut>(_onAuthenticationEventSignOut);
    on<AuthenticationEventAuthenticateUser>(
      _onAuthenticationEventAuthenticateUser,
    );
  }

  void _onAuthenticationEventSignInWithEmail(
    AuthenticationEventSignInWithEmail event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(AuthenticationLoading());
      final authResponse = await authenticationRepository.signInWithEmail(
        event.email,
        event.password,
      );
      emit(
        AuthenticationAuthenticated(
          session: authResponse.session!,
          timestamp: DateTime.now(),
        ),
      );
    } catch (e) {
      emit(
        AuthenticationError(message: e.toString(), timestamp: DateTime.now()),
      );
    }
  }

  void _onAuthenticationEventSignUpWithEmail(
    AuthenticationEventSignUpWithEmail event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(AuthenticationLoading());
      final authResponse = await authenticationRepository.signUpWithEmail(
        event.email,
        event.password,
      );
      emit(
        AuthenticationAuthenticated(
          session: authResponse.session!,
          timestamp: DateTime.now(),
        ),
      );
    } catch (e) {
      emit(
        AuthenticationError(message: e.toString(), timestamp: DateTime.now()),
      );
    }
  }

  void _onAuthenticationEventSignOut(
    AuthenticationEventSignOut event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(AuthenticationLoading());
      await authenticationRepository.signOut();
      emit(AuthenticationUnauthenticated());
    } catch (e) {
      emit(
        AuthenticationError(message: e.toString(), timestamp: DateTime.now()),
      );
    }
  }

  void _onAuthenticationEventAuthenticateUser(
    AuthenticationEventAuthenticateUser event,
    Emitter<AuthenticationState> emit,
  ) async {}
}
