import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String email;
  final String pseudo;
  final DateTime createdAt;

  const UserProfile({
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

  @override
  List<Object?> get props => [id, email, pseudo, createdAt];
}
