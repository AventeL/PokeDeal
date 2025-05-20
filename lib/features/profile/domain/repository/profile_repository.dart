import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/profile/data/profile_data_source_interface.dart';

import '../model/user_profile_with_stats.dart';

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

  Future<UserProfileWithStats> getProfileWithStats({required String id}) async {
    return await profileDataSource.getProfileWithStats(id: id);
  }

  Future<void> updateProfile({
    required UserProfile user,
    required String password,
    required UserProfile currentUser,
  }) async {
    await profileDataSource.updateProfile(
      user: user,
      password: password,
      currentUser: currentUser,
    );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    await profileDataSource.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      email: email,
    );
  }
}
