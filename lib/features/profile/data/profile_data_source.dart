import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/profile/data/profile_data_source_interface.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileDataSource implements IProfileDataSource {
  @override
  Future<UserProfile> getProfile({required String id}) {
    // TODO: implement getProfile
    throw UnimplementedError();
  }

  @override
  Future<void> updateProfile({
    required UserProfile user,
    required UserProfile currentUser,
    required String password,
  }) async {
    print(
      'Updating profile for user: ${currentUser.email}, current user: ${currentUser.pseudo}',
    );
    final authResponse = await Supabase.instance.client.auth.signInWithPassword(
      email: currentUser.email,
      password: password,
    );

    if (authResponse.session == null) {
      throw Exception('Mot de passe incorrect.');
    }

    await Supabase.instance.client
        .from('user_profiles')
        .update({'pseudo': user.pseudo, 'email': user.email})
        .eq('id', user.id);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    final authResponse = await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: currentPassword,
    );

    if (authResponse.session == null) {
      throw Exception('Identifiant incorrect.');
    }

    await Supabase.instance.client.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }
}
