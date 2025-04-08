part of 'profile_bloc.dart';

class ProfileEvent {}

class ProfileLoadEvent extends ProfileEvent {
  final String userId;

  ProfileLoadEvent({required this.userId});
}
