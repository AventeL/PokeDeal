import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/discussion/domain/model/message.dart';

void main() {
  group('Message', () {
    test('should create a valid Message instance', () {
      final date = DateTime.now();
      final message = Message(
        id: 'm1',
        discussionId: 'd1',
        senderId: 'u1',
        content: 'Hello',
        sendAt: date,
        type: MessageType.normal,
      );

      expect(message.id, 'm1');
      expect(message.discussionId, 'd1');
      expect(message.senderId, 'u1');
      expect(message.content, 'Hello');
      expect(message.sendAt, date);
      expect(message.type, MessageType.normal);
    });

    test('fromJson should create Message from valid JSON', () {
      final now = DateTime.now();
      final json = {
        'id': 'm1',
        'discussion_id': 'd1',
        'sender_id': 'u1',
        'content': 'Hello',
        'send_at': now.toIso8601String(),
        'type': 0,
      };

      final message = Message.fromJson(json);

      expect(message.id, 'm1');
      expect(message.discussionId, 'd1');
      expect(message.senderId, 'u1');
      expect(message.content, 'Hello');
      expect(message.sendAt.toIso8601String(), now.toIso8601String());
      expect(message.type, MessageType.normal);
    });

    test('fromJson throws exception on unknown message type', () {
      final json = {
        'id': 'm2',
        'discussion_id': 'd1',
        'sender_id': 'u2',
        'content': 'Hi',
        'send_at': DateTime.now().toIso8601String(),
        'type': 99, // invalid type
      };

      expect(() => Message.fromJson(json), throwsException);
    });

    test('supports value equality', () {
      final date = DateTime.now();
      final message1 = Message(
        id: 'm1',
        discussionId: 'd1',
        senderId: 'u1',
        content: 'Hello',
        sendAt: date,
        type: MessageType.normal,
      );

      final message2 = Message(
        id: 'm1',
        discussionId: 'd1',
        senderId: 'u1',
        content: 'Hello',
        sendAt: date,
        type: MessageType.normal,
      );

      expect(message1, equals(message2));
    });
  });
}
