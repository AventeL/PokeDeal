class UserProfile {
  final String id;
  final String email;
  final String pseudo;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.email,
    required this.pseudo,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      email: json['email'],
      pseudo: json['pseudo'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
