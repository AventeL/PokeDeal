import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';
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
  String? selectedCardId;
  VariantValue? selectedVariantValue;

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
            return StatefulBuilder(
              builder: (context, setState) {
                String title;
                if (selectedSerieIndex == null) {
                  title = "Choisir une série";
                } else if (selectedSetIndex == null) {
                  title = "Choisir un set";
                } else if (selectedCardId == null) {
                  title = "Choisir une carte";
                } else {
                  title = "Choisir une rareté";
                }

                return Column(
                  children: [
                    _buildHeader(title, setState),
                    const Divider(height: 1),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if (selectedSerieIndex == null) {
                            return _buildSeriesSelection(state, setState);
                          } else if (selectedSetIndex == null) {
                            return _buildSetSelection(state, setState);
                          } else if (selectedCardId == null) {
                            return _buildCardSelection(state, setState);
                          } else {
                            return _buildVariantSelection(state);
                          }
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          }

          return const Center(child: Text('Erreur ou données indisponibles.'));
        },
      ),
    );
  }

  Widget _buildHeader(String title, void Function(void Function()) setState) {
    bool canGoBack =
        selectedSerieIndex != null ||
        selectedSetIndex != null ||
        selectedCardId != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          if (canGoBack)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  if (selectedCardId != null) {
                    selectedCardId = null;
                  } else if (selectedSetIndex != null) {
                    selectedSetIndex = null;
                  } else if (selectedSerieIndex != null) {
                    selectedSerieIndex = null;
                  }
                });
              },
            )
          else
            const SizedBox(width: 48),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildSeriesSelection(
    UserCollectionAllLoaded state,
    void Function(void Function()) setState,
  ) {
    final series = state.seriesCollection;

    if (series.isEmpty) {
      return const Center(child: Text('Aucune série disponible.'));
    }

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
  }

  Widget _buildSetSelection(
    UserCollectionAllLoaded state,
    void Function(void Function()) setState,
  ) {
    final series = state.seriesCollection;
    final sets = state.setsCollection;
    final serieId = series[selectedSerieIndex!].id;
    final setsOfSerie =
        sets.where((set) => set.serieBrief.id == serieId).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
  }

  Widget _buildCardSelection(
    UserCollectionAllLoaded state,
    void Function(void Function()) setState,
  ) {
    final series = state.seriesCollection;
    final sets = state.setsCollection;
    final cards = state.listOfCards;
    final serieId = series[selectedSerieIndex!].id;
    final setsOfSerie =
        sets.where((set) => set.serieBrief.id == serieId).toList();
    final selectedSet = setsOfSerie[selectedSetIndex!];

    final cardsOfSet =
        cards.where((card) => card.setBrief.id == selectedSet.id).toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CardListWidget(
              onTapCard: (String cardId) {
                setState(() {
                  selectedCardId = cardId;
                });
              },
              cards: cardsOfSet.map((c) => c.toBrief()).toList(),
              userCardsCollection: [],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVariantSelection(UserCollectionAllLoaded state) {
    final userCardsCollection = state.userCardsCollection;
    final cards = state.listOfCards;

    final variantValuesAvailable =
        userCardsCollection
            .where((card) => card.cardId == selectedCardId)
            .map((card) => card.variant)
            .toSet()
            .toList();

    return ListView.builder(
      itemCount: variantValuesAvailable.length,
      itemBuilder: (context, index) {
        final variant = variantValuesAvailable[index];
        return ListTile(
          title: Text(variant.getFullName),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            selectedVariantValue = variant;
            Navigator.of(context).pop({
              'variantValue': selectedVariantValue,
              'card': cards.firstWhere((c) => c.id == selectedCardId),
            });
          },
        );
      },
    );
  }
}
