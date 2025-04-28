import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedeal/core/widgets/empty_space.dart';
import 'package:pokedeal/features/collection/domain/models/card/base_pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';
import 'package:pokedeal/features/collection/presentation/bloc/card_bloc/collection_pokemon_card_bloc.dart';
import 'package:pokedeal/features/collection/presentation/bloc/user_collection/user_collection_bloc.dart';
import 'package:pokedeal/features/collection/presentation/widgets/card_list_widget.dart';
import 'package:pokedeal/features/collection/presentation/widgets/pokemon_card_unavailable_widget.dart';
import 'package:pokedeal/features/collection/presentation/widgets/pokemon_card_widget.dart';
import 'package:pokedeal/features/collection/presentation/widgets/pokemon_set_card.dart';
import 'package:pokedeal/features/trade/domain/models/trade_request_data.dart';

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
            ],
          ),
        ),
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
        if (state is CollectionPokemonCardsGet) {}
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
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      8.height,
                      Text(
                        card.setBrief.name,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      8.height,
                      Text(
                        tradeRequestData.variantValue?.getFullName ?? '',
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
      color: Theme.of(
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
    final selectedCard = await showModalBottomSheet<BasePokemonCard>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: buildSeriesAndCardsSelector(tradeRequestData),
          ),
        );
      },
    );

    if (selectedCard != null) {
      selectCard(tradeRequestData, selectedCard);
    }
  }

  void selectCard(
    TradeRequestData tradeRequestData,
    BasePokemonCard selectedCard,
  ) {
    setState(() {
      if (tradeRequestData.userId == otherUserTrade.userId) {
        otherUserCard = selectedCard;
        otherUserTrade = TradeRequestData(
          userId: otherUserTrade.userId,
          cardId: selectedCard.id,
          variantValue: VariantValue.normal,
        );
      }
      if (tradeRequestData.userId == myTrade.userId) {
        myCard = selectedCard;
        myTrade = TradeRequestData(
          userId: myTrade.userId,
          cardId: selectedCard.id,
          variantValue: VariantValue.normal,
        );
      }
    });
  }

  Widget buildSeriesAndCardsSelector(TradeRequestData tradeRequestData) {
    int? selectedSerieIndex;
    int? selectedSetIndex;

    return BlocBuilder<UserCollectionBloc, UserCollectionState>(
      builder: (context, state) {
        if (state is UserCollectionLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is UserCollectionAllLoaded) {
          final series = state.seriesCollection;
          final sets = state.setsCollection;
          final cards = state.listOfCards;

          return StatefulBuilder(
            builder: (context, setState) {
              if (selectedSerieIndex == null) {
                return ListView.builder(
                  itemCount: series.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(series[index].name),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        setState(() {
                          selectedSerieIndex = index;
                        });
                      },
                    );
                  },
                );
              } else if (selectedSetIndex == null) {
                final serieId = series[selectedSerieIndex!].id;
                final setsOfSerie =
                    sets.where((set) => set.serieBrief.id == serieId).toList();

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListView.builder(
                    itemCount: setsOfSerie.length,
                    itemBuilder: (context, index) {
                      return PokemonSetCardWidget(
                        onTap: () {
                          setState(() {
                            selectedSetIndex = index;
                          });
                        },
                        displayStats: false,
                        set: setsOfSerie[index].toBrief(),
                      );
                    },
                  ),
                );
              } else {
                final serieId = series[selectedSerieIndex!].id;
                final setsOfSerie =
                    sets.where((set) => set.serieBrief.id == serieId).toList();
                final selectedSet = setsOfSerie[selectedSetIndex!];

                final cardsOfSet =
                    cards
                        .where((card) => card.setBrief.id == selectedSet.id)
                        .toList();

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CardListWidget(
                          onTapCard: (String cardId) {
                            Navigator.of(context).pop(
                              cardsOfSet.firstWhere(
                                (element) => element.id == cardId,
                              ),
                            );
                          },
                          cards:
                              cardsOfSet
                                  .map((element) => element.toBrief())
                                  .toList(),
                          userCardsCollection: [],
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          );
        }

        return const Center(child: Text('Erreur ou données indisponibles.'));
      },
    );
  }
}
