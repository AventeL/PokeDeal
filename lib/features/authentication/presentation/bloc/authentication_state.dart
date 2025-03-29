part of 'authentication_bloc.dart';

class AuthenticationState {}

final class AuthenticationInitial extends AuthenticationState {}

final class AuthenticationLoading extends AuthenticationState {}

final class AuthenticationAuthenticated extends AuthenticationState {
  final Session session;

  AuthenticationAuthenticated(this.session);
}

final class AuthenticationUnauthenticated extends AuthenticationState {}

final class AuthenticationError extends AuthenticationState {
  final String message;

  AuthenticationError(this.message);
}
