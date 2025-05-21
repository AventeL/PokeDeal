import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';
import 'package:pokedeal/features/trade/data/trade_data_source_interface.dart';
import 'package:pokedeal/features/trade/domain/models/trade.dart';
import 'package:pokedeal/features/trade/domain/models/trade_request_data.dart';
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
          .select('quantity')
          .eq('user_id', userId);

      final cardCount = (cardCountResponse as List).fold(
        0,
        (sum, item) => sum + (item['quantity'] as int),
      );

      final exchangesResponse = await supabaseClient
          .from('exchanges')
          .select('id')
          .or('sender_id.eq.$userId,receiver_id.eq.$userId')
          .eq('status', 'accepted');

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

    final List<Trade> data =
        response.map((trade) {
          return Trade(
            id: trade['id'] as String,
            senderId: UserProfile.fromJson(trade['sender']),
            receiveId: UserProfile.fromJson(trade['receiver']),
            status: TradeStatusExtension.fromString(trade['status'] as String),
            timestamp: DateTime.parse(trade['created_at'] as String),
            senderCardId: trade['sender_card_id'] as String,
            receiverCardId: trade['receiver_card_id'] as String,
            senderCardVariant: VariantValueExtension.fromJson(
              trade['sender_card_variant'] as String,
            ),
            receiverCardVariant: VariantValueExtension.fromJson(
              trade['receiver_card_variant'] as String,
            ),
          );
        }).toList();

    return data;
  }

  @override
  Future<List<Trade>> getReceivedTrade() async {
    final response = await supabaseClient
        .from('exchanges')
        .select('*, sender:sender_id(*), receiver:receiver_id(*)')
        .eq('receiver_id', supabaseClient.auth.currentUser!.id);

    final List<Trade> data =
        response.map((trade) {
          return Trade(
            id: trade['id'] as String,
            senderId: UserProfile.fromJson(trade['sender']),
            receiveId: UserProfile.fromJson(trade['receiver']),
            status: TradeStatusExtension.fromString(trade['status'] as String),
            timestamp: DateTime.parse(trade['created_at'] as String),
            senderCardId: trade['sender_card_id'] as String,
            receiverCardId: trade['receiver_card_id'] as String,
            senderCardVariant: VariantValueExtension.fromJson(
              trade['sender_card_variant'] as String,
            ),
            receiverCardVariant: VariantValueExtension.fromJson(
              trade['receiver_card_variant'] as String,
            ),
          );
        }).toList();

    return data;
  }

  @override
  Future<void> askTrade({
    required TradeRequestData myTradeRequestData,
    required TradeRequestData otherTradeRequestData,
  }) async {
    await supabaseClient.rpc(
      'create_exchange',
      params: {
        'sender': myTradeRequestData.userId,
        'receiver': otherTradeRequestData.userId,
        'sender_card_id': myTradeRequestData.cardId,
        'sender_card_variant': myTradeRequestData.variantValue?.getFullName,
        'receiver_card_id': otherTradeRequestData.cardId,
        'receiver_card_variant':
            otherTradeRequestData.variantValue?.getFullName,
      },
    );
  }

  @override
  Future<void> acceptTrade({required String tradeId}) async {
    await supabaseClient
        .from('exchanges')
        .update({'status': TradeStatus.accepted.toStringForApi})
        .eq('id', tradeId);
  }

  @override
  Future<void> refuseTrade({required String tradeId}) async {
    await supabaseClient
        .from('exchanges')
        .update({'status': TradeStatus.refused.toStringForApi})
        .eq('id', tradeId);
  }
}
