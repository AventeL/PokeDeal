import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/profile/domain/repository/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<ProfileLoadEvent>(onProfileLoadEvent);
  }

  Future<void> onProfileLoadEvent(
    ProfileLoadEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      UserProfile? userProfile = await profileRepository.getProfile(
        id: event.userId,
      );
      if (userProfile == null) {
        emit(ProfileError(message: "User profile not found"));
        return;
      }
      emit(ProfileLoaded(userProfile: userProfile));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}
