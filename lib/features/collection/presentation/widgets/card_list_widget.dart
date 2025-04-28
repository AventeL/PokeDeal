import 'package:flutter/material.dart';
import 'package:pokedeal/features/collection/domain/models/card/pokemon_card_brief.dart';
import 'package:pokedeal/features/collection/domain/models/card/user_card_collection.dart';
import 'package:pokedeal/features/collection/presentation/widgets/pokemon_card_widget.dart';

import 'pokemon_card_unavailable_widget.dart';

class CardListWidget extends StatelessWidget {
  final List<PokemonCardBrief> cards;
  final List<UserCardCollection> userCardsCollection;
  final Function(String cardId)? onLongPressCard;
  final Function(String cardId)? onTapCard;
  final bool showOwnIndicator;

  const CardListWidget({
    super.key,
    required this.cards,
    required this.userCardsCollection,
    this.onLongPressCard,
    this.onTapCard,
    this.showOwnIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        PokemonCardBrief card = cards[index];

        if (card.image == null) {
          return PokemonCardUnavailableWidget(
            card: card,
            totalCard: cards.length,
            isOwned:
                showOwnIndicator
                    ? userCardsCollection.any(
                      (userCard) => userCard.cardId == card.id,
                    )
                    : false,
            onLongPress:
                onLongPressCard != null
                    ? () => onLongPressCard!(card.id)
                    : null,
            onTap: onTapCard != null ? () => onTapCard!(card.id) : null,
          );
        }

        return PokemonCardWidget(
          cardUrl: card.image!,
          onLongPress:
              onLongPressCard != null ? () => onLongPressCard!(card.id) : null,
          onTap: onTapCard != null ? () => onTapCard!(card.id) : null,
          isOwned:
              showOwnIndicator
                  ? userCardsCollection.any(
                    (userCard) => userCard.cardId == card.id,
                  )
                  : false,
        );
      },
    );
  }
}
