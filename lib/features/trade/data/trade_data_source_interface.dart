import 'package:pokedeal/features/trade/domain/models/userStats.dart';

import '../domain/models/trade.dart';

abstract class ITradeDataSource {
  Future<List<Userstats>> getAllUser();

  Future<List<Trade>> getSendTrade();

  Future<List<Trade>> getReceivedTrade();
}
