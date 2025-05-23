import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedeal/core/widgets/empty_space.dart';
import 'package:pokedeal/features/collection/domain/models/card/base_pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';
import 'package:pokedeal/features/collection/presentation/bloc/card_bloc/collection_pokemon_card_bloc.dart';
import 'package:pokedeal/features/collection/presentation/bloc/user_collection/user_collection_bloc.dart';
import 'package:pokedeal/features/collection/presentation/widgets/pokemon_card_unavailable_widget.dart';
import 'package:pokedeal/features/collection/presentation/widgets/pokemon_card_widget.dart';
import 'package:pokedeal/features/trade/domain/models/trade_request_data.dart';
import 'package:pokedeal/features/trade/presentation/bloc/trade_bloc.dart';
import 'package:pokedeal/features/trade/presentation/widgets/bottom_sheet_card_selector.dart';
import 'package:pokedeal/shared/widgets/custom_large_button.dart';

class TradeRequestPage extends StatefulWidget {
  final TradeRequestData otherUserTradeRequest;
  final TradeRequestData myTradeRequest;

  const TradeRequestPage({
    super.key,
    required this.otherUserTradeRequest,
    required this.myTradeRequest,
  });

  @override
  State<TradeRequestPage> createState() => _TradeRequestPageState();
}

class _TradeRequestPageState extends State<TradeRequestPage> {
  late TradeRequestData myTrade;
  late TradeRequestData otherUserTrade;
  BasePokemonCard? myCard;
  BasePokemonCard? otherUserCard;

  @override
  void initState() {
    super.initState();
    myTrade = widget.myTradeRequest;
    otherUserTrade = widget.otherUserTradeRequest;

    if (myTrade.cardId != null) {
      context.read<CollectionPokemonCardBloc>().add(
        CollectionPokemonGetCardEvent(cardId: myTrade.cardId!),
      );
    }
    if (otherUserTrade.cardId != null) {
      context.read<CollectionPokemonCardBloc>().add(
        CollectionPokemonGetCardEvent(cardId: otherUserTrade.cardId!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<TradeBloc, TradeState>(
        listener: (context, tradeState) {
          if (tradeState is TradeStateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(tradeState.message),
                duration: const Duration(seconds: 2),
              ),
            );
          }
          if (tradeState is TradeStateAskTradeSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Votre demande d'échange a été envoyée"),
                duration: Duration(seconds: 2),
              ),
            );
            context.pop();
          }
        },
        builder: (context, tradeState) {
          if (tradeState is TradeStateLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    16.height,
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              'Vous proposez : ',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            4.height,
                            buildCardSelector(myTrade, myCard),
                            16.height,
                            Text(
                              "Vous recevez : ",
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            4.height,
                            buildCardSelector(otherUserTrade, otherUserCard),
                          ],
                        ),
                      ),
                    ),
                    16.height,
                    CustomLargeButton(
                      label: "Demander",
                      onPressed: () {
                        if (canSendTrade()) {
                          context.read<TradeBloc>().add(
                            TradeEventAskTrade(
                              myTradeRequestData: myTrade,
                              otherTradeRequestData: otherUserTrade,
                            ),
                          );
                        }
                      },
                      isActive: canSendTrade(),
                    ),
                    16.height,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildCardSelector(
    TradeRequestData tradeRequestData,
    BasePokemonCard? card,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.onTertiaryContainer.withValues(alpha: 0.1),
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(16),
      ),
      child: buildCardDisplay(tradeRequestData),
    );
  }

  Widget buildCardDisplay(TradeRequestData tradeRequestData) {
    final BasePokemonCard? card =
        tradeRequestData.userId == myTrade.userId ? myCard : otherUserCard;

    return BlocConsumer<CollectionPokemonCardBloc, CollectionPokemonCardState>(
      listener: (context, state) {
        if (state is CollectionPokemonCardsGet) {
          setState(() {
            if (tradeRequestData.userId == myTrade.userId &&
                myTrade.cardId != null) {
              myCard = state.card;
              myTrade = TradeRequestData(
                userId: myTrade.userId,
                cardId: state.card.id,
                variantValue: myTrade.variantValue ?? VariantValue.normal,
              );
            }
            if (tradeRequestData.userId == otherUserTrade.userId &&
                otherUserTrade.cardId != null) {
              otherUserCard = state.card;
              otherUserTrade = TradeRequestData(
                userId: otherUserTrade.userId,
                cardId: state.card.id,
                variantValue:
                    otherUserTrade.variantValue ?? VariantValue.normal,
              );
            }
          });
        }
      },
      builder: (context, state) {
        if (state is CollectionPokemonCardLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (card != null && tradeRequestData.cardId != null) {
          return Row(
            children: [
              16.width,
              Column(
                children: [
                  16.height,
                  SizedBox(
                    height: 208,
                    width: 151,
                    child:
                        card.image != null
                            ? PokemonCardWidget(
                              cardUrl: card.image!,
                              onTap: () => onCardTap(tradeRequestData),
                            )
                            : PokemonCardUnavailableWidget(
                              onTap: () => onCardTap(tradeRequestData),
                              card: card.toBrief(),
                              totalCard: card.setBrief.cardCount.total,
                            ),
                  ),
                  16.height,
                ],
              ),
              Flexible(
                flex: 9,
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        card.name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      8.height,
                      Text(
                        card.setBrief.name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      8.height,
                      Text(
                        tradeRequestData.variantValue?.getFullName ?? '',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: buildNoSelectedCard(tradeRequestData),
            ),
            Flexible(
              child: Text(
                "Aucune carte sélectionnée",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildNoSelectedCard(TradeRequestData tradeRequestData) {
    BorderRadius borderRadius = BorderRadius.circular(8);
    return Material(
      color:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withValues(alpha: 0.2)
              : Theme.of(
                context,
              ).colorScheme.onTertiaryContainer.withValues(alpha: 0.2),
      borderRadius: borderRadius,
      child: InkWell(
        splashColor: Theme.of(context).primaryColor,
        borderRadius: borderRadius,
        onTap: () => onCardTap(tradeRequestData),
        child: Container(
          height: 208,
          width: 151,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: borderRadius,
          ),
          child: const Center(child: Icon(Icons.add)),
        ),
      ),
    );
  }

  void onCardTap(TradeRequestData tradeRequestData) async {
    context.read<UserCollectionBloc>().add(
      UserCollectionLoadAllEvent(userId: tradeRequestData.userId),
    );

    final selectedResult = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: BottomSheetCardSelector(tradeRequestData: tradeRequestData),
          ),
        );
      },
    );

    final BasePokemonCard selectedCard = selectedResult?['card'];
    final VariantValue selectedVariantValue =
        selectedResult?['variantValue'] ?? VariantValue.normal;

    if (selectedResult != null) {
      selectCard(tradeRequestData, selectedCard, selectedVariantValue);
    }
  }

  bool canSendTrade() {
    return myTrade.cardId != null &&
        otherUserTrade.cardId != null &&
        myTrade.userId != otherUserTrade.userId &&
        myTrade.variantValue != null &&
        otherUserTrade.variantValue != null;
  }

  void selectCard(
    TradeRequestData tradeRequestData,
    BasePokemonCard selectedCard,
    VariantValue selectedVariantValue,
  ) {
    setState(() {
      if (tradeRequestData.userId == otherUserTrade.userId) {
        otherUserCard = selectedCard;
        otherUserTrade = TradeRequestData(
          userId: otherUserTrade.userId,
          cardId: selectedCard.id,
          variantValue: selectedVariantValue,
        );
      }
      if (tradeRequestData.userId == myTrade.userId) {
        myCard = selectedCard;
        myTrade = TradeRequestData(
          userId: myTrade.userId,
          cardId: selectedCard.id,
          variantValue: selectedVariantValue,
        );
      }
    });
  }
}
