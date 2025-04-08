import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/profile/data/profile_data_source_interface.dart';

class ProfileDataSource implements IProfileDataSource {
  @override
  Future<UserProfile> getProfile({required String id}) {
    // TODO: implement getProfile
    throw UnimplementedError();
  }
}
