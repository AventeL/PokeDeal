import 'package:pokedeal/features/trade/data/trade_data_source_interface.dart';
import 'package:pokedeal/features/trade/domain/models/trade.dart';
import 'package:pokedeal/features/trade/domain/models/trade_request_data.dart';
import 'package:pokedeal/features/trade/domain/models/user_stats.dart';

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
    listTradeFromSupabase.sort((a, b) {
      return b.timestamp.compareTo(a.timestamp);
    });
    return listTradeFromSupabase;
  }

  Future<List<Trade>> getReceivedTrade() async {
    List<Trade> listTradeFromSupabase =
        await tradeDataSource.getReceivedTrade();
    listTradeFromSupabase.sort((a, b) {
      return b.timestamp.compareTo(a.timestamp);
    });
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

  Future<void> acceptTrade({required Trade trade}) async {
    await tradeDataSource.acceptTrade(trade: trade);
  }

  Future<void> refuseTrade({required String tradeId}) async {
    await tradeDataSource.refuseTrade(tradeId: tradeId);
  }
}
