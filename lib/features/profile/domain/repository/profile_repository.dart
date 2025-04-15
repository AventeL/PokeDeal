import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/profile/data/profile_data_source_interface.dart';

class ProfileRepository {
  final IProfileDataSource profileDataSource;

  ProfileRepository({required this.profileDataSource});

  Future<UserProfile?> getProfile({required String id}) async {
    if (getIt<AuthenticationRepository>().userProfile != null &&
        id == getIt<AuthenticationRepository>().userProfile!.id) {
      return getIt<AuthenticationRepository>().getUserProfile();
    } else {
      return await profileDataSource.getProfile(id: id);
    }
  }
}
