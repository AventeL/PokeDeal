import 'package:pokedeal/features/discussion/data/discussion_data_source_interface.dart';
import 'package:pokedeal/features/discussion/domain/model/discussion.dart';
import 'package:pokedeal/features/discussion/domain/model/message.dart';

class DiscussionRepository {
  final IDiscussionDataSource discussionDataSource;

  DiscussionRepository({required this.discussionDataSource});

  Future<Discussion> getDiscussionByTradeId(String tradeId) async {
    return await discussionDataSource.getDiscussionByTradeId(tradeId);
  }

  Future<Message> sendMessage(Message message) async {
    return await discussionDataSource.sendMessage(message);
  }

  Stream<Message> subscribeToMessages(String discussionId) {
    return discussionDataSource.subscribeToMessages(discussionId);
  }
}
