part of 'authentication_bloc.dart';

class AuthenticationEvent {}

final class AuthenticationEventAuthenticateUser extends AuthenticationEvent {}

final class AuthenticationEventSignOut extends AuthenticationEvent {}

final class AuthenticationEventSignInWithEmail extends AuthenticationEvent {
  final String email;
  final String password;

  AuthenticationEventSignInWithEmail(this.email, this.password);
}

final class AuthenticationEventSignUpWithEmail extends AuthenticationEvent {
  final String email;
  final String password;

  AuthenticationEventSignUpWithEmail(this.email, this.password);
}
