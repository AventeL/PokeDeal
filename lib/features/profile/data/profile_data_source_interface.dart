import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';

abstract class IProfileDataSource {
  Future<UserProfile> getProfile({required String id});
}
