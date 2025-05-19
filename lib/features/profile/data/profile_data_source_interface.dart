import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/profile/domain/model/user_profile_with_stats.dart';

abstract class IProfileDataSource {
  Future<UserProfile> getProfile({required String id});

  Future<UserProfileWithStats> getProfileWithStats({required String id});

  Future<void> updateProfile({
    required UserProfile user,
    required UserProfile currentUser,
    required String password,
  });

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  });
}
