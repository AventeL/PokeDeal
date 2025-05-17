import 'package:pokedeal/features/trade/domain/models/trade_request_data.dart';
import 'package:pokedeal/features/trade/domain/models/user_stats.dart';

import '../domain/models/trade.dart';

abstract class ITradeDataSource {
  Future<List<UserStats>> getAllUser();

  Future<List<Trade>> getSendTrade();

  Future<List<Trade>> getReceivedTrade();

  Future<void> askTrade({
    required TradeRequestData myTradeRequestData,
    required TradeRequestData otherTradeRequestData,
  });

  Future<void> acceptTrade({required String tradeId});

  Future<void> refuseTrade({required String tradeId});
}
