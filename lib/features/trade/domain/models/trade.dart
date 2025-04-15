import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';

class Trade {
  final String id;
  final UserProfile sender_id;
  final UserProfile receive_id;
  final String status;
  final DateTime timestamp;

  Trade({
    required this.id,
    required this.receive_id,
    required this.sender_id,
    required this.status,
    required this.timestamp,
  });

  factory Trade.fromJson(Map<String, dynamic> json) {
    return Trade(
      id: json['id'] as String,
      receive_id: json['receive_id'] as UserProfile,
      sender_id: json['sender_id'] as UserProfile,
      status: json['status'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
