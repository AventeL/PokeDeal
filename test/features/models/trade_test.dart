import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart'
    show VariantValue;
import 'package:pokedeal/features/trade/domain/models/enum/trade_status.dart';
import 'package:pokedeal/features/trade/domain/models/trade.dart';

void main() {
  test('Trade has a constructor', () {
    DateTime now = DateTime.now();
    UserProfile sender = UserProfile(
      id: 'senderId',
      email: 'sender@test.com',
      pseudo: 'Sender',
      createdAt: now,
    );
    UserProfile receiver = UserProfile(
      id: 'receiverId',
      email: 'receiver@test.com',
      pseudo: 'Receiver',
      createdAt: now,
    );

    Trade trade = Trade(
      id: 'tradeId',
      senderId: sender,
      receiveId: receiver,
      status: TradeStatus.waiting,
      timestamp: now,
      senderCardId: 'senderCardId',
      receiverCardId: 'receiverCardId',
      senderCardVariant: VariantValue.normal,
      receiverCardVariant: VariantValue.holo,
    );

    expect(trade.id, 'tradeId');
    expect(trade.senderId, sender);
    expect(trade.receiveId, receiver);
    expect(trade.status, TradeStatus.waiting);
    expect(trade.timestamp, now);
  });

  test('Trade has a fromJson', () {
    DateTime now = DateTime.now();
    Trade trade = Trade.fromJson({
      'id': 'tradeId',
      'sender_id': {
        'id': 'senderId',
        'email': 'sender@test.com',
        'pseudo': 'Sender',
        'created_at': now.toIso8601String(),
      },
      'receive_id': {
        'id': 'receiverId',
        'email': 'receiver@test.com',
        'pseudo': 'Receiver',
        'created_at': now.toIso8601String(),
      },
      'status': 'waiting',
      'timestamp': now.toIso8601String(),
      'sender_card_id': 'senderCardId',
      'receiver_card_id': 'receiverCardId',
      'sender_card_variant': 'Normal',
      'receiver_card_variant': 'Holo',
    });

    expect(trade.id, 'tradeId');
    expect(trade.senderId.id, 'senderId');
    expect(trade.receiveId.id, 'receiverId');
    expect(trade.status, TradeStatus.waiting);
    expect(trade.timestamp, now);
  });

  test('Trade copyWith updates status', () {
    DateTime now = DateTime.now();
    UserProfile sender = UserProfile(
      id: 'senderId',
      email: 'sender@test.com',
      pseudo: 'Sender',
      createdAt: now,
    );
    UserProfile receiver = UserProfile(
      id: 'receiverId',
      email: 'receiver@test.com',
      pseudo: 'Receiver',
      createdAt: now,
    );

    Trade trade = Trade(
      id: 'tradeId',
      senderId: sender,
      receiveId: receiver,
      status: TradeStatus.waiting,
      timestamp: now,
      senderCardId: 'senderCardId',
      receiverCardId: 'receiverCardId',
      senderCardVariant: VariantValue.normal,
      receiverCardVariant: VariantValue.holo,
    );

    Trade updatedTrade = trade.copyWith(status: TradeStatus.accepted);

    expect(updatedTrade.id, trade.id);
    expect(updatedTrade.senderId, trade.senderId);
    expect(updatedTrade.receiveId, trade.receiveId);
    expect(updatedTrade.timestamp, trade.timestamp);
    expect(updatedTrade.senderCardId, trade.senderCardId);
    expect(updatedTrade.receiverCardId, trade.receiverCardId);
    expect(updatedTrade.senderCardVariant, trade.senderCardVariant);
    expect(updatedTrade.receiverCardVariant, trade.receiverCardVariant);
    expect(updatedTrade.status, TradeStatus.accepted);
  });

  test('TradeStatus toStringForApi returns correct string', () {
    expect(TradeStatus.accepted.toStringForApi, 'accepted');
    expect(TradeStatus.refused.toStringForApi, 'refused');
    expect(TradeStatus.waiting.toStringForApi, 'waiting');
  });
}
