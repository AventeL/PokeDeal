import 'package:pokedeal/features/discussion/data/discussion_data_source_interface.dart';
import 'package:pokedeal/features/discussion/domain/model/Discussion.dart';

class DiscussionRepository {
  final IDiscussionDataSource discussionDataSource;

  DiscussionRepository({required this.discussionDataSource});

  Future<Discussion> getDiscussionByTradeId(String tradeId) async {
    return await discussionDataSource.getDiscussionByTradeId(tradeId);
  }
}
