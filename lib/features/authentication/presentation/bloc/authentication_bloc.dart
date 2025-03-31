import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';

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
  }

  void _onAuthenticationEventSignInWithEmail(
    AuthenticationEventSignInWithEmail event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(AuthenticationLoading());
      final user = await authenticationRepository.signInWithEmail(
        event.email,
        event.password,
      );
      emit(
        AuthenticationAuthenticated(
          userProfile: user,
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
      final user = await authenticationRepository.signUpWithEmail(
        event.email,
        event.password,
        event.pseudo,
      );
      emit(
        AuthenticationAuthenticated(
          userProfile: user,
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
}
