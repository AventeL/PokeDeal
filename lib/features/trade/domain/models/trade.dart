import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';

import 'enum/trade_status.dart';

class Trade {
  final String id;
  final UserProfile senderId;
  final UserProfile receiveId;
  final TradeStatus status;
  final DateTime timestamp;
  final String senderCardId;
  final String receiverCardId;
  final VariantValue senderCardVariant;
  final VariantValue receiverCardVariant;

  Trade({
    required this.id,
    required this.receiveId,
    required this.senderId,
    required this.status,
    required this.timestamp,
    required this.senderCardId,
    required this.receiverCardId,
    required this.senderCardVariant,
    required this.receiverCardVariant,
  });

  factory Trade.fromJson(Map<String, dynamic> json) {
    return Trade(
      id: json['id'] as String,
      senderId: UserProfile.fromJson(json['sender_id'] as Map<String, dynamic>),
      receiveId: UserProfile.fromJson(
        json['receive_id'] as Map<String, dynamic>,
      ),
      status: TradeStatusExtension.fromString(json['status'] as String),
      timestamp: DateTime.parse(json['timestamp'] as String),
      senderCardId: json['sender_card_id'] as String,
      receiverCardId: json['receiver_card_id'] as String,
      senderCardVariant: VariantValueExtension.fromJson(
        json['sender_card_variant'],
      ),
      receiverCardVariant: VariantValueExtension.fromJson(
        json['receiver_card_variant'],
      ),
    );
  }

  Trade copyWith({required TradeStatus status}) {
    return Trade(
      id: id,
      senderId: senderId,
      receiveId: receiveId,
      status: status,
      timestamp: timestamp,
      senderCardId: senderCardId,
      receiverCardId: receiverCardId,
      senderCardVariant: senderCardVariant,
      receiverCardVariant: receiverCardVariant,
    );
  }
}
