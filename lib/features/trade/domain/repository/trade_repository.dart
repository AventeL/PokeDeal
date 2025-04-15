import 'package:pokedeal/features/trade/domain/models/userStats.dart';

import '../../data/trade_data_source_interface.dart';
import '../models/trade.dart';

class TradeRepository {
  final ITradeDataSource tradeDataSource;

  TradeRepository({required this.tradeDataSource});

  Future<List<Userstats>> getAllUser() async {
    List<Userstats> listUserProfileFromSupabase =
        await tradeDataSource.getAllUser();
    return listUserProfileFromSupabase;
  }

  Future<List<Trade>> getSendTrade() async {
    List<Trade> listTradeFromSupabase = await tradeDataSource.getSendTrade();
    print(listTradeFromSupabase);
    return listTradeFromSupabase;
  }

  Future<List<Trade>> getReceivedTrade() async {
    List<Trade> listTradeFromSupabase =
        await tradeDataSource.getReceivedTrade();
    print(listTradeFromSupabase);
    return listTradeFromSupabase;
  }
}
