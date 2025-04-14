import 'package:pokedeal/features/trade/domain/models/userStats.dart';

abstract class ITradeDataSource {
  Future<List<Userstats>> getAllUser();
}
