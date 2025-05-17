import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/features/discussion/data/discussion_data_source_interface.dart';
import 'package:pokedeal/features/discussion/domain/model/discussion.dart';
import 'package:pokedeal/features/discussion/domain/model/message.dart';

class DiscussionDataSource implements IDiscussionDataSource {
  @override
  Future<Discussion> getDiscussionByTradeId(String tradeId) async {
    final discussionResponse =
        await supabaseClient
            .from('exchange_discussions')
            .select()
            .eq('exchange_id', tradeId)
            .single();

    final discussionId = discussionResponse['id'] as String;

    final messagesResponse = await supabaseClient
        .from('exchange_messages')
        .select()
        .eq('discussion_id', discussionId)
        .order('send_at');

    final List<Message> messages =
        (messagesResponse as List).map((json) {
          return Message.fromJson(json);
        }).toList();

    return Discussion(id: discussionId, tradeId: tradeId, messages: messages);
  }

  @override
  Future<Message> sendMessage(Message message) async {
    final response =
        await supabaseClient
            .from('exchange_messages')
            .insert({
              'discussion_id': message.discussionId,
              'sender_id': message.senderId,
              'content': message.content,
            })
            .select()
            .single();

    return Message.fromJson(response);
  }

  @override
  Stream<Message> subscribeToMessages(String discussionId) {
    return supabaseClient
        .from('exchange_messages')
        .stream(primaryKey: ['id'])
        .eq('discussion_id', discussionId)
        .order('send_at')
        .map((event) => event.map((json) => Message.fromJson(json)))
        .expand(
          (messages) => messages,
        ); // transform List<Message> en Stream<Message>
  }
}
