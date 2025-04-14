import 'package:pokedeal/features/trade/domain/models/userStats.dart';

import '../../data/trade_data_source_interface.dart';

class TradeRepository {
  final ITradeDataSource tradeDataSource;

  TradeRepository({required this.tradeDataSource});

  Future<List<Userstats>> getAllUser() async {
    List<Userstats> listUserProfileFromSupabase =
        await tradeDataSource.getAllUser();
    return listUserProfileFromSupabase;
  }
}
