import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';

abstract class IProfileDataSource {
  Future<UserProfile> getProfile({required String id});

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
