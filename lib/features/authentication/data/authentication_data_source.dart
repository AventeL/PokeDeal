import 'package:pokedeal/features/authentication/data/authentication_data_source_interface.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationDataSource implements IAuthenticationDataSource {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  @override
  Future<UserProfile> signInWithEmail(String email, String password) async {
    final authResponse = await supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = authResponse.user;
    if (user == null) {
      throw Exception('Authentification échouée, aucun utilisateur trouvé');
    }

    final response =
        await supabaseClient
            .from('user_profiles')
            .select()
            .eq('id', user.id)
            .single();

    return UserProfile.fromJson(response);
  }

  @override
  Future<UserProfile> signUpWithEmail(
    String email,
    String password,
    String pseudo,
  ) async {
    final authResponse = await supabaseClient.auth.signUp(
      email: email,
      password: password,
    );

    if (authResponse.session == null) {
      throw Exception("Aucune session n'a été trouvée");
    }

    final response =
        await supabaseClient
            .from('user_profiles')
            .insert({
              'id': authResponse.user!.id,
              'email': email,
              'pseudo': pseudo,
            })
            .select()
            .single();

    return UserProfile.fromJson(response);
  }

  @override
  Future<UserProfile?> getUserProfile() async {
    if (Supabase.instance.client.auth.currentUser == null) {
      return null;
    }
    final supabaseClient = Supabase.instance.client;

    final response =
        await supabaseClient
            .from('user_profiles')
            .select()
            .eq('id', supabaseClient.auth.currentUser!.id)
            .single();

    return UserProfile.fromJson(response);
  }

  @override
  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }
}
