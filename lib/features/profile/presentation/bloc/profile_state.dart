part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final UserProfileWithStats userProfile;

  const ProfileLoaded({required this.userProfile});

  @override
  List<Object> get props => [userProfile];
}

final class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object> get props => [message];
}

final class ProfileUpdated extends ProfileState {
  final UserProfile userProfile;

  const ProfileUpdated({required this.userProfile});

  @override
  List<Object> get props => [userProfile];
}

final class ChangePasswordSuccess extends ProfileState {}
