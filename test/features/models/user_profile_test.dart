import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';

void main() {
  test('UserProfile has a constructorl', () {
    DateTime now = DateTime.now();
    UserProfile profile = UserProfile(
      id: 'id',
      email: 'test@gmail.com',
      pseudo: 'pseudo',
      createdAt: now,
    );
    expect(profile.id, 'id');
    expect(profile.email, 'test@gmail.com');
    expect(profile.pseudo, 'pseudo');
    expect(profile.createdAt, now);
  });

  test('UserProfile has a fromJson', () {
    UserProfile profile = UserProfile.fromJson({
      "id": "12345",
      "email": "test@gmail.com",
      "pseudo": "testUser",
      "created_at": "2023-10-01T12:00:00Z",
    });
    expect(profile.id, "12345");
    expect(profile.email, "test@gmail.com");
    expect(profile.pseudo, "testUser");
    expect(profile.createdAt, DateTime.parse("2023-10-01T12:00:00Z"));
  });
}
