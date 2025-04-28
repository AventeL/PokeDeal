import 'package:pokedeal/features/trade/data/trade_data_source_interface.dart';
import 'package:pokedeal/features/trade/domain/models/trade.dart';
import 'package:pokedeal/features/trade/domain/models/user_stats.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../authentication/domain/models/user_profile.dart';
import '../domain/models/enum/trade_status.dart';

class TradeDataSource implements ITradeDataSource {
  final SupabaseClient supabaseClient;

  TradeDataSource({required this.supabaseClient});

  @override
  Future<List<UserStats>> getAllUser() async {
    final response = await supabaseClient
        .from('user_profiles')
        .select()
        .neq('id', supabaseClient.auth.currentUser!.id);

    final List<dynamic> data = response;
    final List<UserStats> usersWithStats = [];
    for (final user in data) {
      final userId = user['id'];

      final cardCountResponse = await supabaseClient
          .from('user_cards')
          .select('id')
          .eq('user_id', userId);

      final cardCount = cardCountResponse.length;

      final exchangesResponse = await supabaseClient
          .from('exchanges')
          .select('id')
          .or('sender_id.eq.$userId,receiver_id.eq.$userId')
          .eq('status', 'success');

      final successfulExchanges = exchangesResponse.length;
      usersWithStats.add(
        UserStats(
          user: UserProfile.fromJson(user),
          nbCards: cardCount,
          nbExchanges: successfulExchanges,
        ),
      );
    }
    return usersWithStats;
  }

  @override
  Future<List<Trade>> getSendTrade() async {
    final response = await supabaseClient
        .from('exchanges')
        .select('*, sender:sender_id(*), receiver:receiver_id(*)')
        .eq('sender_id', supabaseClient.auth.currentUser!.id);
    final List<dynamic> data = response;
    return data.map((trade) {
      return Trade(
        id: trade['id'] as String,
        senderId: UserProfile.fromJson(trade['sender']),
        receiveId: UserProfile.fromJson(trade['receiver']),
        status: trade['status'] as TradeStatus,
        timestamp: DateTime.parse(trade['created_at'] as String),
      );
    }).toList();
  }

  @override
  Future<List<Trade>> getReceivedTrade() async {
    final response = await supabaseClient
        .from('exchanges')
        .select('*, sender:sender_id(*), receiver:receiver_id(*)')
        .eq('receiver_id', supabaseClient.auth.currentUser!.id);
    final List<dynamic> data = response;
    return data.map((trade) {
      return Trade(
        id: trade['id'] as String,
        senderId: UserProfile.fromJson(trade['sender']),
        receiveId: UserProfile.fromJson(trade['receiver']),
        status: trade['status'] as TradeStatus,
        timestamp: DateTime.parse(trade['created_at'] as String),
      );
    }).toList();
  }
}
