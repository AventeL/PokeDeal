import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/collection/domain/models/card/pokemon_card_brief.dart';
import 'package:pokedeal/features/collection/domain/models/card/user_card_collection.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';
import 'package:pokedeal/features/collection/presentation/bloc/card_bloc/collection_pokemon_card_bloc.dart';
import 'package:pokedeal/features/collection/presentation/widgets/bottom_sheet_ask_trade.dart';
import 'package:pokedeal/features/collection/presentation/widgets/card_list_widget.dart';
import 'package:pokedeal/features/trade/domain/models/trade_request_data.dart';

class CardListPage extends StatelessWidget {
  final List<PokemonCardBrief> cards;
  final List<UserCardCollection> userCardsCollection;
  final bool showOwnIndicator;
  final String userId;
  final String setName;

  const CardListPage({
    super.key,
    required this.cards,
    required this.userCardsCollection,
    this.showOwnIndicator = false,
    required this.userId,
    required this.setName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(setName)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: SingleChildScrollView(
          child: CardListWidget(
            cards: cards,
            userCardsCollection: userCardsCollection,
            onLongPressCard:
                (cardId) => showAskTradeBottomSheet(context, cardId),
            onTapCard: (cardId) {
              context.push(
                '/card_details',
                extra: {
                  'cardId': cardId,
                  'cardBrief': cards.firstWhere((card) => card.id == cardId),
                  'userId': userId,
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void showAskTradeBottomSheet(BuildContext context, String cardId) {
    if (userId != getIt<AuthenticationRepository>().userProfile!.id) {
      context.read<CollectionPokemonCardBloc>().add(
        CollectionPokemonGetCardEvent(cardId: cardId),
      );

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder:
            (context) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: BlocConsumer<
                CollectionPokemonCardBloc,
                CollectionPokemonCardState
              >(
                listener: (context, state) {
                  if (state is CollectionPokemonCardError) {
                    Navigator.pop(context);
                  }
                },
                builder: (context, state) {
                  if (state is CollectionPokemonCardLoading) {
                    return SizedBox(
                      height: 100,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state is CollectionPokemonCardsGet) {
                    return BottomSheetAskTrade(
                      availableVariants: getAvailableVariants(cardId),
                      card: state.card,
                      onConfirm: (variant) {
                        context.push(
                          '/trade_request',
                          extra: {
                            'otherUserTradeRequest': TradeRequestData(
                              cardId: cardId,
                              userId: userId,
                              variantValue: variant,
                            ),
                          },
                        );
                      },
                    );
                  }

                  return const Center(child: Text('Aucune données à afficher'));
                },
              ),
            ),
      );
    }
  }

  List<VariantValue> getAvailableVariants(String cardId) {
    List<VariantValue> variants = [];
    for (var card in userCardsCollection) {
      if (card.cardId == cardId) {
        variants.add(card.variant);
      }
    }

    return variants;
  }
}
