import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/core/widgets/empty_space.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/collection/domain/models/card/base_pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';
import 'package:pokedeal/features/collection/presentation/bloc/card_bloc/collection_pokemon_card_bloc.dart';
import 'package:pokedeal/features/collection/presentation/widgets/pokemon_card_unavailable_widget.dart';
import 'package:pokedeal/features/collection/presentation/widgets/pokemon_card_widget.dart';
import 'package:pokedeal/features/discussion/domain/model/discussion.dart';
import 'package:pokedeal/features/discussion/domain/model/message.dart';
import 'package:pokedeal/features/discussion/presentation/bloc/discussion_bloc.dart';
import 'package:pokedeal/features/discussion/presentation/widgets/message_widget.dart';
import 'package:pokedeal/features/trade/domain/models/enum/trade_status.dart';
import 'package:pokedeal/features/trade/domain/models/trade.dart';
import 'package:pokedeal/features/trade/presentation/bloc/trade_bloc.dart';
import 'package:pokedeal/shared/widgets/custom_large_button.dart';

class DiscussionPage extends StatefulWidget {
  final Trade trade;

  const DiscussionPage({super.key, required this.trade});

  @override
  State<DiscussionPage> createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  Discussion? discussion;
  late Trade trade;
  final TextEditingController messageController = TextEditingController();
  final String myId = getIt<AuthenticationRepository>().userProfile!.id;
  BasePokemonCard? myCard;
  BasePokemonCard? otherCard;
  bool hasSubscribedToMessages = false;
  bool isMessageLoading = false;

  @override
  void initState() {
    super.initState();
    trade = widget.trade;
    context.read<DiscussionBloc>().add(
      DiscussionEventGetDiscussionByTradeId(tradeId: trade.id),
    );
    context.read<CollectionPokemonCardBloc>().add(
      CollectionPokemonGetCardsByIdsEvent(
        cardIds: [trade.senderCardId, trade.receiverCardId],
      ),
    );
  }

  @override
  void dispose() {
    getIt<DiscussionBloc>().add(DiscussionEventUnsubscribeFromMessages());
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Echange avec ${trade.receiveId.id == myId ? trade.senderId.pseudo : trade.receiveId.pseudo}",
          style: const TextStyle(fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<TradeBloc, TradeState>(
          listener: (context, state) {
            if (state is TradeStateError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is TradeStateAcceptTradeSuccess) {
              trade = trade.copyWith(status: TradeStatus.accepted);
            }
            if (state is TradeStateRefuseTradeSuccess) {
              trade = trade.copyWith(status: TradeStatus.refused);
            }
          },
          builder: (context, state) {
            return BlocConsumer<DiscussionBloc, DiscussionState>(
              listener: (context, state) {
                isMessageLoading = state is DiscussionStateLoadingMessage;

                if (state is DiscussionStateError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
                if (state is DiscussionStateDiscussionGet ||
                    state is DiscussionStateMessageSent) {
                  discussion =
                      state is DiscussionStateDiscussionGet
                          ? state.discussion
                          : discussion;
                  if (!hasSubscribedToMessages) {
                    context.read<DiscussionBloc>().add(
                      DiscussionEventSubscribeToMessages(
                        discussionId: discussion!.id,
                      ),
                    );
                    hasSubscribedToMessages = true;
                  }
                }
              },
              builder: (context, state) {
                if (state is DiscussionStateLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is DiscussionStateDiscussionGet ||
                    state is DiscussionStateLoadingMessage) {
                  return buildBody(discussion);
                }

                return const Center(child: Text('Aucune discussion.'));
              },
            );
          },
        ),
      ),
    );
  }

  Widget buildBody(Discussion? discussion) {
    if (discussion == null) {
      return const Center(child: Text('Aucune discussion trouvée.'));
    }

    final messages = discussion.messages;

    return Column(
      children: [
        Expanded(
          child:
              messages.isEmpty
                  ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        buildTradePropose(trade),
                        16.height,
                        const Text('Aucun message dans cette discussion.'),
                      ],
                    ),
                  )
                  : ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMine = message.senderId == myId;

                      return Column(
                        children: [
                          if (index == messages.length - 1)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: buildTradePropose(trade),
                            ),
                          Align(
                            alignment:
                                isMine
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                            child: MessageWidget(message: message),
                          ),
                          if (isMessageLoading &&
                              message.id == messages.first.id)
                            Align(
                              alignment: Alignment.centerRight,
                              child: MessageWidget(
                                message: message,
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
        ),

        buildTextField(),
      ],
    );
  }

  void _sendMessage() {
    final content = messageController.text.trim();
    if (content.isEmpty || discussion == null) return;

    context.read<DiscussionBloc>().add(
      DiscussionEventSendMessage(
        message: Message(
          id: '',
          discussionId: discussion!.id,
          senderId: myId,
          content: content,
          sendAt: DateTime.now(),
          type: MessageType.normal,
        ),
      ),
    );

    messageController.clear();
  }

  void addMessage(Message message) {
    setState(() {
      if (discussion == null && !discussion!.messages.contains(message)) {
        discussion?.messages.insert(0, message);
      }
    });
  }

  Widget buildTradePropose(Trade trade) {
    return BlocBuilder<CollectionPokemonCardBloc, CollectionPokemonCardState>(
      builder: (context, state) {
        if (state is CollectionPokemonCardsByIdsGet) {
          myCard =
              trade.senderId.id == myId
                  ? state.cards[trade.senderCardId]
                  : state.cards[trade.receiverCardId];
          otherCard =
              trade.senderId.id == myId
                  ? state.cards[trade.receiverCardId]
                  : state.cards[trade.senderCardId];
        }

        return Container(
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Proposition d\'échange',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              16.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  16.width,
                  Column(
                    children: [
                      Text(
                        "Vous recevez",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      8.height,
                      state is CollectionPokemonCardLoading
                          ? CircularProgressIndicator()
                          : buildCardDisplay(
                            otherCard,
                            trade.senderId.id == myId
                                ? trade.receiverCardVariant
                                : trade.senderCardVariant,
                          ),
                    ],
                  ),
                  Icon(Icons.compare_arrows),
                  Column(
                    children: [
                      Text(
                        "Vous donnez",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      8.height,
                      state is CollectionPokemonCardLoading
                          ? CircularProgressIndicator()
                          : buildCardDisplay(
                            myCard,
                            trade.senderId.id == myId
                                ? trade.senderCardVariant
                                : trade.receiverCardVariant,
                          ),
                    ],
                  ),
                  16.width,
                ],
              ),
              16.height,
              BlocBuilder<TradeBloc, TradeState>(
                builder: (context, state) {
                  if (state is TradeStateLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Row(
                    children: [
                      if (trade.status == TradeStatus.accepted)
                        Flexible(child: buildTradeAcceptedInfo()),
                      if (trade.status == TradeStatus.refused)
                        Flexible(child: buildTradeRefusedInfo()),
                      if (trade.status == TradeStatus.waiting &&
                          trade.senderId.id == myId)
                        Flexible(child: buildTradeWaitingInfo()),
                      if (trade.status == TradeStatus.waiting &&
                          trade.senderId.id != myId) ...[
                        Flexible(
                          child: SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {
                                context.read<TradeBloc>().add(
                                  TradeEventRefuseTrade(tradeId: trade.id),
                                );
                              },
                              child: Text("Refuser"),
                            ),
                          ),
                        ),
                        16.width,
                        Flexible(
                          child: CustomLargeButton(
                            label: "Accepter",
                            onPressed: () {
                              context.read<TradeBloc>().add(
                                TradeEventAcceptTrade(trade: trade),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildCardDisplay(BasePokemonCard? card, VariantValue variant) {
    if (card == null) {
      return const SizedBox(height: 208 / 2, width: 151 / 2);
    }

    return Column(
      children: [
        SizedBox(
          height: 208 / 2,
          width: 151 / 2,
          child:
              card.image != null
                  ? PokemonCardWidget(cardUrl: card.image!)
                  : PokemonCardUnavailableWidget(
                    card: card.toBrief(),
                    totalCard: card.setBrief.cardCount.total,
                  ),
        ),
        8.height,
        SizedBox(
          width: 151 / 2,
          child: Column(
            children: [
              Text(card.name, maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(variant.getFullName),
              Text(
                card.setBrief.name,
                style: const TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      color: Colors.black.withValues(alpha: 0.5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: const InputDecoration(
                hintText: 'Écrire un message...',
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(icon: const Icon(Icons.send), onPressed: _sendMessage),
        ],
      ),
    );
  }

  Widget buildTradeAcceptedInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Échange accepté',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            16.height,
            Text(
              'Vous avez accepté l\'échange avec ${trade.receiveId.id == myId ? trade.senderId.pseudo : trade.receiveId.pseudo}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTradeRefusedInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Échange refusé',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            16.height,
            Text(
              'Vous avez refusé l\'échange avec ${trade.receiveId.id == myId ? trade.senderId.pseudo : trade.receiveId.pseudo}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTradeWaitingInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.orangeAccent.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Échange en attente',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            16.height,
            Text(
              'Vous devez attendre la réponse de ${trade.receiveId.id == myId ? trade.senderId.pseudo : trade.receiveId.pseudo}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
