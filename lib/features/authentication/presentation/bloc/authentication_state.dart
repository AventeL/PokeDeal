part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

final class AuthenticationInitial extends AuthenticationState {}

final class AuthenticationLoading extends AuthenticationState {}

final class AuthenticationAuthenticated extends AuthenticationState {
  final UserProfile userProfile;
  final DateTime timestamp;

  AuthenticationAuthenticated({
    required this.userProfile,
    required this.timestamp,
  });

  @override
  List<Object> get props => [userProfile, timestamp];
}

final class AuthenticationUnauthenticated extends AuthenticationState {}

final class AuthenticationError extends AuthenticationState {
  final String message;
  final DateTime timestamp;

  AuthenticationError({required this.message, required this.timestamp});

  @override
  List<Object> get props => [message, timestamp];
}
