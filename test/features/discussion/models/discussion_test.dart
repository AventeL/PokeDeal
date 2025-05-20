import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/discussion/domain/model/discussion.dart';
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

  group('Discussion', () {
    final now = DateTime.now();
    final message1 = Message(
      id: 'm1',
      discussionId: 'd1',
      senderId: 'u1',
      content: 'Hello',
      sendAt: now,
      type: MessageType.normal,
    );

    final message2 = Message(
      id: 'm2',
      discussionId: 'd1',
      senderId: 'u2',
      content: 'Hi',
      sendAt: now,
      type: MessageType.request,
    );

    test('should create a valid Discussion instance', () {
      final discussion = Discussion(
        id: 'd1',
        tradeId: 't1',
        messages: [message1, message2],
      );

      expect(discussion.id, 'd1');
      expect(discussion.tradeId, 't1');
      expect(discussion.messages.length, 2);
      expect(discussion.messages[0], message1);
      expect(discussion.messages[1], message2);
    });

    test('copyWith should update properties correctly', () {
      final discussion = Discussion(
        id: 'd1',
        tradeId: 't1',
        messages: [message1],
      );

      final copy = discussion.copyWith(id: 'd2', messages: [message2]);

      expect(copy.id, 'd2');
      expect(copy.tradeId, 't1'); // unchanged
      expect(copy.messages, [message2]);
    });

    test('fromJson should create Discussion from valid JSON', () {
      final json = {
        'id': 'd1',
        'tradeId': 't1',
        'messages': [
          {
            'id': 'm1',
            'discussion_id': 'd1',
            'sender_id': 'u1',
            'content': 'Hello',
            'send_at': now.toIso8601String(),
            'type': 0,
          },
          {
            'id': 'm2',
            'discussion_id': 'd1',
            'sender_id': 'u2',
            'content': 'Hi',
            'send_at': now.toIso8601String(),
            'type': 1,
          },
        ],
      };

      final discussion = Discussion.fromJson(json);

      expect(discussion.id, 'd1');
      expect(discussion.tradeId, 't1');
      expect(discussion.messages.length, 2);
      expect(discussion.messages[0].id, 'm1');
      expect(discussion.messages[1].type, MessageType.request);
    });

    test('supports value equality', () {
      final discussion1 = Discussion(
        id: 'd1',
        tradeId: 't1',
        messages: [message1, message2],
      );

      final discussion2 = Discussion(
        id: 'd1',
        tradeId: 't1',
        messages: [message1, message2],
      );

      expect(discussion1, equals(discussion2));
    });
  });
}
