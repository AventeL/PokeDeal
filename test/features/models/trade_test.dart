import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
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
      status: 'En cours',
      timestamp: now,
    );

    expect(trade.id, 'tradeId');
    expect(trade.senderId, sender);
    expect(trade.receiveId, receiver);
    expect(trade.status, 'En cours');
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
      'status': 'En cours',
      'timestamp': now.toIso8601String(),
    });

    expect(trade.id, 'tradeId');
    expect(trade.senderId.id, 'senderId');
    expect(trade.receiveId.id, 'receiverId');
    expect(trade.status, 'En cours');
    expect(trade.timestamp, now);
  });
}
