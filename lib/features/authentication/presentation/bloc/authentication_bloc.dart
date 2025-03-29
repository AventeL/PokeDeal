import 'package:bloc/bloc.dart';
import 'package:pokedeal/features/Authentication/domain/repository/authentication_repository.dart';
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
      emit(AuthenticationAuthenticated(authResponse.session!));
    } catch (e) {
      emit(AuthenticationError(e.toString()));
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
      emit(AuthenticationAuthenticated(authResponse.session!));
    } catch (e) {
      emit(AuthenticationError(e.toString()));
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
      emit(AuthenticationError(e.toString()));
    }
  }

  void _onAuthenticationEventAuthenticateUser(
    AuthenticationEventAuthenticateUser event,
    Emitter<AuthenticationState> emit,
  ) async {}
}
