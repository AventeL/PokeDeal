import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedeal/features/collection/domain/models/card/pokemon_card_brief.dart';
import 'package:pokedeal/features/collection/domain/models/card/user_card_collection.dart';
import 'package:pokedeal/features/collection/presentation/widgets/card_list_widget.dart';

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
}
