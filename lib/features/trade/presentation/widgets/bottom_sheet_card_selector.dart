import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedeal/features/collection/presentation/bloc/user_collection/user_collection_bloc.dart';
import 'package:pokedeal/features/collection/presentation/widgets/card_list_widget.dart';
import 'package:pokedeal/features/collection/presentation/widgets/pokemon_set_card.dart';
import 'package:pokedeal/features/trade/domain/models/trade_request_data.dart';

class BottomSheetCardSelector extends StatefulWidget {
  final TradeRequestData tradeRequestData;

  const BottomSheetCardSelector({super.key, required this.tradeRequestData});

  @override
  State<BottomSheetCardSelector> createState() =>
      _BottomSheetCardSelectorState();
}

class _BottomSheetCardSelectorState extends State<BottomSheetCardSelector> {
  int? selectedSerieIndex;
  int? selectedSetIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: BlocBuilder<UserCollectionBloc, UserCollectionState>(
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
                      sets
                          .where((set) => set.serieBrief.id == serieId)
                          .toList();

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListView.builder(
                      itemCount: setsOfSerie.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: PokemonSetCardWidget(
                            onTap: () {
                              setState(() {
                                selectedSetIndex = index;
                              });
                            },
                            displayStats: false,
                            set: setsOfSerie[index].toBrief(),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  final serieId = series[selectedSerieIndex!].id;
                  final setsOfSerie =
                      sets
                          .where((set) => set.serieBrief.id == serieId)
                          .toList();
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
      ),
    );
  }
}
