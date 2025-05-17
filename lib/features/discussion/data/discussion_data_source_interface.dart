import 'package:pokedeal/features/discussion/domain/model/discussion.dart';
import 'package:pokedeal/features/discussion/domain/model/message.dart';

abstract class IDiscussionDataSource {
  Future<Discussion> getDiscussionByTradeId(String tradeId);

  Future<Message> sendMessage(Message message);

  Stream<Message> subscribeToMessages(String discussionId);
}
