import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final String discussionId;
  final String senderId;
  final String content;
  final DateTime sendAt;
  final MessageType type;

  const Message({
    required this.id,
    required this.discussionId,
    required this.senderId,
    required this.content,
    required this.sendAt,
    required this.type,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      discussionId: json['discussion_id'] as String,
      senderId: json['sender_id'] as String,
      content: json['content'] as String,
      sendAt: DateTime.parse(json['send_at']),
      type: MessageTypeExtension.fromInt(json['type'] as int),
    );
  }

  @override
  List<Object?> get props => [
    id,
    discussionId,
    senderId,
    content,
    sendAt,
    type,
  ];
}

enum MessageType { normal, request }

extension MessageTypeExtension on MessageType {
  String get name {
    switch (this) {
      case MessageType.normal:
        return 'normal';
      case MessageType.request:
        return 'request';
    }
  }

  static MessageType fromInt(int type) {
    switch (type) {
      case 0:
        return MessageType.normal;
      case 1:
        return MessageType.request;
      default:
        throw Exception('Unknown message type: $type');
    }
  }
}
