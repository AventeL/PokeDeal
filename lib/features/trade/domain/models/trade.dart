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
      sender_id: UserProfile.fromJson(
        json['sender_id'] as Map<String, dynamic>,
      ),
      receive_id: UserProfile.fromJson(
        json['receive_id'] as Map<String, dynamic>,
      ),
      status: json['status'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
