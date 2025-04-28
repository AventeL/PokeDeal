part of 'profile_bloc.dart';

class ProfileEvent {}

class ProfileLoadEvent extends ProfileEvent {
  final String userId;

  ProfileLoadEvent({required this.userId});
}

class ProfileUpdateEvent extends ProfileEvent {
  final UserProfile user;
  final UserProfile currentUser;
  final String password;

  ProfileUpdateEvent({
    required this.user,
    required this.currentUser,
    required this.password,
  });
}
