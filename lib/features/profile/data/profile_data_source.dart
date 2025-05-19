import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/profile/data/profile_data_source_interface.dart';
import 'package:pokedeal/features/profile/domain/model/user_profile_with_stats.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileDataSource implements IProfileDataSource {
  @override
  Future<UserProfile> getProfile({required String id}) async {
    final response =
        await supabaseClient
            .from('user_profiles')
            .select()
            .eq('id', id)
            .single();

    return UserProfile.fromJson(response);
  }

  @override
  Future<UserProfileWithStats> getProfileWithStats({required String id}) async {
    final response =
        await supabaseClient
            .from('user_profiles')
            .select()
            .eq('id', id)
            .single();

    final collectionsResponse = await supabaseClient
        .from('user_cards')
        .select('quantity')
        .eq('user_id', id);

    final nbcards = (collectionsResponse as List).fold(
      0,
      (sum, item) => sum + (item['quantity'] as int),
    );

    final tradesResponse = await supabaseClient
        .from('exchanges')
        .select('id')
        .or('sender_id.eq.$id,receiver_id.eq.$id')
        .eq('status', "accepted");

    final nbexchange = (tradesResponse as List).length;

    final seriesResponse = await supabaseClient
        .from('user_cards')
        .select('set_id')
        .eq('user_id', id);

    final uniqueSeries =
        (seriesResponse as List).map((item) => item['set_id']).toSet();

    final nbseries = uniqueSeries.length;

    UserProfileWithStats userProfileWithStats = UserProfileWithStats(
      user: UserProfile.fromJson(response),
      nbcards: nbcards,
      nbexchange: nbexchange,
      nbseries: nbseries,
    );

    return userProfileWithStats;
  }

  @override
  Future<void> updateProfile({
    required UserProfile user,
    required UserProfile currentUser,
    required String password,
  }) async {
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

  @override
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
