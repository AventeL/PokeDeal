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
      sender_id: sender,
      receive_id: receiver,
      status: 'En cours',
      timestamp: now,
    );

    expect(trade.id, 'tradeId');
    expect(trade.sender_id, sender);
    expect(trade.receive_id, receiver);
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
    expect(trade.sender_id.id, 'senderId');
    expect(trade.receive_id.id, 'receiverId');
    expect(trade.status, 'En cours');
    expect(trade.timestamp, now);
  });
}
