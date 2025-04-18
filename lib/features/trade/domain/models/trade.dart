import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';

class Trade {
  final String id;
  final UserProfile senderId;
  final UserProfile receiveId;
  final String status;
  final DateTime timestamp;

  Trade({
    required this.id,
    required this.receiveId,
    required this.senderId,
    required this.status,
    required this.timestamp,
  });

  factory Trade.fromJson(Map<String, dynamic> json) {
    return Trade(
      id: json['id'] as String,
      senderId: UserProfile.fromJson(json['sender_id'] as Map<String, dynamic>),
      receiveId: UserProfile.fromJson(
        json['receive_id'] as Map<String, dynamic>,
      ),
      status: json['status'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
