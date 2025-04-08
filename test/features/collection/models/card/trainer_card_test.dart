import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/collection/domain/models/card/card_variant.dart';
import 'package:pokedeal/features/collection/domain/models/card/trainer_card.dart';
import 'package:pokedeal/features/collection/domain/models/card_count.dart';
import 'package:pokedeal/features/collection/domain/models/enum/card_category.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_brief.dart';

void main() {
  test('TrainerCard has a fromJson', () {
    final json = {
      "id": "swsh35-58",
      "localId": "58",
      "name": "Professor’s Research",
      "image": "https://images.pokemontcg.io/swsh35/58.png",
      "category": "trainer",
      "illustrator": "Ken Sugimori",
      "rarity": "Rare",
      "set": {
        "name": "Champion’s Path",
        "id": "swsh35",
        "logo": "https://example.com/logo.png",
        "symbol": "https://example.com/symbol.png",
        "cardCount": {
          "total": 80,
          "official": 80,
          "first_edition": null,
          "holo": 20,
          "reverse": 60,
          "normal": 80,
        },
      },
      "variants": {
        "firstEdition": false,
        "holo": true,
        "reverse": true,
        "wPromo": false,
        "normal": false,
      },
      "effect": "Discard your hand and draw 7 cards.",
      "trainerType": "Supporter",
    };

    final trainerCard = TrainerCard.fromJson(json);

    expect(trainerCard.id, "swsh35-58");
    expect(trainerCard.localId, "58");
    expect(trainerCard.name, "Professor’s Research");
    expect(trainerCard.image, "https://images.pokemontcg.io/swsh35/58.png");
    expect(trainerCard.category, CardCategory.trainer);
    expect(trainerCard.illustrator, "Ken Sugimori");
    expect(trainerCard.rarity, "Rare");
    expect(trainerCard.setBrief.name, "Champion’s Path");
    expect(trainerCard.setBrief.id, "swsh35");
    expect(trainerCard.setBrief.logoUrl, "https://example.com/logo.png");
    expect(trainerCard.setBrief.symbolUrl, "https://example.com/symbol.png");
    expect(trainerCard.setBrief.cardCount.total, 80);
    expect(trainerCard.setBrief.cardCount.official, 80);
    expect(trainerCard.setBrief.cardCount.firstEd, null);
    expect(trainerCard.setBrief.cardCount.holo, 20);
    expect(trainerCard.setBrief.cardCount.reverse, 60);
    expect(trainerCard.setBrief.cardCount.normal, 80);
    expect(trainerCard.variants.firstEdition, false);
    expect(trainerCard.variants.holo, true);
    expect(trainerCard.variants.reverse, true);
    expect(trainerCard.variants.promo, false);
    expect(trainerCard.variants.normal, false);
    expect(trainerCard.effect, "Discard your hand and draw 7 cards.");
    expect(trainerCard.trainerType, "Supporter");
  });

  test('TrainerCard has a constructor', () {
    final card = TrainerCard(
      id: "swsh35-58",
      localId: "58",
      name: "Professor’s Research",
      image: "https://images.pokemontcg.io/swsh35/58.png",
      category: CardCategory.trainer,
      illustrator: "Ken Sugimori",
      rarity: "Rare",
      setBrief: PokemonSetBrief(
        name: "Champion’s Path",
        id: "swsh35",
        logoUrl: "https://example.com/logo.png",
        symbolUrl: "https://example.com/symbol.png",
        cardCount: CardCount(
          total: 80,
          official: 80,
          firstEd: null,
          holo: 20,
          reverse: 60,
          normal: 80,
        ),
      ),
      variants: CardVariant(
        firstEdition: false,
        holo: true,
        reverse: true,
        promo: false,
        normal: false,
      ),
      effect: "Discard your hand and draw 7 cards.",
      trainerType: "Supporter",
    );

    expect(card.id, "swsh35-58");
    expect(card.localId, "58");
    expect(card.name, "Professor’s Research");
    expect(card.image, "https://images.pokemontcg.io/swsh35/58.png");
    expect(card.category, CardCategory.trainer);
    expect(card.illustrator, "Ken Sugimori");
    expect(card.rarity, "Rare");
    expect(card.setBrief.name, "Champion’s Path");
    expect(card.setBrief.id, "swsh35");
    expect(card.setBrief.logoUrl, "https://example.com/logo.png");
    expect(card.setBrief.symbolUrl, "https://example.com/symbol.png");
    expect(card.setBrief.cardCount.total, 80);
    expect(card.setBrief.cardCount.official, 80);
    expect(card.setBrief.cardCount.firstEd, null);
    expect(card.setBrief.cardCount.holo, 20);
    expect(card.setBrief.cardCount.reverse, 60);
    expect(card.setBrief.cardCount.normal, 80);
    expect(card.variants.firstEdition, false);
    expect(card.variants.holo, true);
    expect(card.variants.reverse, true);
    expect(card.variants.promo, false);
    expect(card.variants.normal, false);
    expect(card.effect, "Discard your hand and draw 7 cards.");
    expect(card.trainerType, "Supporter");
  });
}
