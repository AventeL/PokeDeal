import 'package:equatable/equatable.dart';
import 'package:pokedeal/features/discussion/domain/model/message.dart';

class Discussion extends Equatable {
  final String id;
  final String tradeId;
  final List<Message> messages;

  const Discussion({
    required this.id,
    required this.tradeId,
    required this.messages,
  });

  Discussion copyWith({String? id, String? tradeId, List<Message>? messages}) {
    return Discussion(
      id: id ?? this.id,
      tradeId: tradeId ?? this.tradeId,
      messages: messages ?? this.messages,
    );
  }

  factory Discussion.fromJson(Map<String, dynamic> json) {
    return Discussion(
      id: json['id'] as String,
      tradeId: json['tradeId'] as String,
      messages:
          (json['messages'] as List<dynamic>)
              .map((message) => Message.fromJson(message))
              .toList(),
    );
  }

  @override
  List<Object?> get props => [id, tradeId, messages];
}
