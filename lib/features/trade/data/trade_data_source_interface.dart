import 'package:pokedeal/features/trade/domain/models/user_stats.dart';

import '../domain/models/trade.dart';

abstract class ITradeDataSource {
  Future<List<UserStats>> getAllUser();

  Future<List<Trade>> getSendTrade();

  Future<List<Trade>> getReceivedTrade();
}
