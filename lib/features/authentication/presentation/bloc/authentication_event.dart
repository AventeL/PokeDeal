part of 'authentication_bloc.dart';

class AuthenticationEvent {}

final class AuthenticationEventSignOut extends AuthenticationEvent {}

final class AuthenticationEventSignInWithEmail extends AuthenticationEvent {
  final String email;
  final String password;

  AuthenticationEventSignInWithEmail(this.email, this.password);
}

final class AuthenticationEventSignUpWithEmail extends AuthenticationEvent {
  final String email;
  final String password;
  final String pseudo;

  AuthenticationEventSignUpWithEmail(this.email, this.password, this.pseudo);
}
