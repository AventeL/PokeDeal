import 'package:pokedeal/features/trade/domain/models/trade_request_data.dart';
import 'package:pokedeal/features/trade/domain/models/user_stats.dart';

import '../../data/trade_data_source_interface.dart';
import '../models/trade.dart';

class TradeRepository {
  final ITradeDataSource tradeDataSource;

  TradeRepository({required this.tradeDataSource});

  Future<List<UserStats>> getAllUser() async {
    List<UserStats> listUserProfileFromSupabase =
        await tradeDataSource.getAllUser();
    return listUserProfileFromSupabase;
  }

  Future<List<Trade>> getSendTrade() async {
    List<Trade> listTradeFromSupabase = await tradeDataSource.getSendTrade();
    return listTradeFromSupabase;
  }

  Future<List<Trade>> getReceivedTrade() async {
    List<Trade> listTradeFromSupabase =
        await tradeDataSource.getReceivedTrade();
    return listTradeFromSupabase;
  }

  Future<void> askTrade({
    required TradeRequestData myTradeRequestData,
    required TradeRequestData otherTradeRequestData,
  }) async {
    await tradeDataSource.askTrade(
      myTradeRequestData: myTradeRequestData,
      otherTradeRequestData: otherTradeRequestData,
    );
  }
}
