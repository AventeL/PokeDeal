import 'package:pokedeal/features/trade/data/trade_data_source_interface.dart';
import 'package:pokedeal/features/trade/domain/models/userStats.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../authentication/domain/models/user_profile.dart';

class TradeDataSource implements ITradeDataSource {
  final SupabaseClient supabaseClient;

  TradeDataSource({required this.supabaseClient});

  @override
  Future<List<Userstats>> getAllUser() async {
    final response = await supabaseClient
        .from('user_profiles')
        .select()
        .neq('id', supabaseClient.auth.currentUser!.id);

    final List<dynamic> data = response;
    final List<Userstats> usersWithStats = [];
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
        Userstats(
          user: UserProfile.fromJson(user),
          nbCards: cardCount,
          nbExchanges: successfulExchanges,
        ),
      );
    }
    return usersWithStats;
  }
}
