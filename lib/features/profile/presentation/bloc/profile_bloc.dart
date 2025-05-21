import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/profile/domain/model/user_profile_with_stats.dart';
import 'package:pokedeal/features/profile/domain/repository/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<ProfileLoadEvent>(onProfileLoadEvent);
    on<ProfileUpdateEvent>(onProfileUpdateEvent);
    on<ChangePasswordEvent>(onChangePasswordEvent);
  }

  Future<void> onProfileLoadEvent(
    ProfileLoadEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      UserProfileWithStats? userProfile = await profileRepository
          .getProfileWithStats(id: event.userId);
      emit(ProfileLoaded(userProfile: userProfile));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> onProfileUpdateEvent(
    ProfileUpdateEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      await profileRepository.updateProfile(
        user: event.user,
        password: event.password,
        currentUser: event.currentUser,
      );
      emit(ProfileUpdated(userProfile: event.user));
      add(ProfileLoadEvent(userId: event.user.id));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> onChangePasswordEvent(
    ChangePasswordEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      await profileRepository.changePassword(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
        email: event.email,
      );
      emit(ChangePasswordSuccess());
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}
