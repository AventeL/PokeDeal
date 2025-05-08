import 'package:pokedeal/features/discussion/domain/model/Discussion.dart';

abstract class IDiscussionDataSource {
  Future<Discussion> getDiscussionByTradeId(String tradeId);
}
