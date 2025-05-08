import 'package:pokedeal/features/discussion/data/discussion_data_source_interface.dart';
import 'package:pokedeal/features/discussion/domain/model/Discussion.dart';

class DiscussionDataSource implements IDiscussionDataSource {
  @override
  Future<Discussion> getDiscussionByTradeId(String tradeId) {
    throw UnimplementedError();
  }
}
