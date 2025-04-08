import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/collection/domain/models/card/card_variant.dart';
import 'package:pokedeal/features/collection/domain/models/card/pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/card_count.dart';
import 'package:pokedeal/features/collection/domain/models/enum/card_category.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_brief.dart';

void main() {
  test('PokemonCard has a fromJson', () {
    final json = {
      "id": "xy7-54",
      "localId": "54",
      "name": "Gardevoir EX",
      "image": "https://images.pokemontcg.io/xy7/54.png",
      "category": "pokémon",
      "illustrator": "5ban Graphics",
      "rarity": "Rare Holo EX",
      "set": {
        "name": "Ancient Origins",
        "id": "xy7",
        "logo": "https://example.com/logo.png",
        "symbol": "https://example.com/symbol.png",
        "cardCount": {
          "total": 98,
          "official": 98,
          "first_edition": null,
          "holo": 50,
          "reverse": 48,
          "normal": 98,
        },
      },
      "variants": {
        "firstEdition": false,
        "holo": true,
        "reverse": false,
        "wPromo": false,
        "normal": false,
      },
      "dexId": [282],
      "hp": 170,
      "types": ["Psychic"],
      "evolveFrom": "Kirlia",
      "description": "This Pokémon can sense emotions and heal people.",
      "level": "EX",
      "stage": "Basic",
      "suffix": "EX",
      "item": null,
    };

    final pokemonCard = PokemonCard.fromJson(json);

    expect(pokemonCard.id, "xy7-54");
    expect(pokemonCard.localId, "54");
    expect(pokemonCard.name, "Gardevoir EX");
    expect(pokemonCard.image, "https://images.pokemontcg.io/xy7/54.png");
    expect(pokemonCard.category, CardCategory.pokemon);
    expect(pokemonCard.illustrator, "5ban Graphics");
    expect(pokemonCard.rarity, "Rare Holo EX");
    expect(pokemonCard.setBrief.name, "Ancient Origins");
    expect(pokemonCard.setBrief.id, "xy7");
    expect(pokemonCard.setBrief.logoUrl, "https://example.com/logo.png");
    expect(pokemonCard.setBrief.symbolUrl, "https://example.com/symbol.png");
    expect(pokemonCard.setBrief.cardCount.total, 98);
    expect(pokemonCard.setBrief.cardCount.official, 98);
    expect(pokemonCard.setBrief.cardCount.firstEd, null);
    expect(pokemonCard.setBrief.cardCount.holo, 50);
    expect(pokemonCard.setBrief.cardCount.reverse, 48);
    expect(pokemonCard.setBrief.cardCount.normal, 98);
    expect(pokemonCard.variants.firstEdition, false);
    expect(pokemonCard.variants.holo, true);
    expect(pokemonCard.variants.reverse, false);
    expect(pokemonCard.variants.promo, false);
    expect(pokemonCard.variants.normal, false);
    expect(pokemonCard.item, null);
  });

  test('PokemonCard has a constructor', () {
    final card = PokemonCard(
      id: "xy7-54",
      localId: "54",
      name: "Gardevoir EX",
      image: "https://images.pokemontcg.io/xy7/54.png",
      category: CardCategory.pokemon,
      illustrator: "5ban Graphics",
      rarity: "Rare Holo EX",
      setBrief: PokemonSetBrief(
        name: "Ancient Origins",
        id: "xy7",
        logoUrl: "https://example.com/logo.png",
        symbolUrl: "https://example.com/symbol.png",
        cardCount: CardCount(
          total: 98,
          official: 98,
          firstEd: null,
          holo: 50,
          reverse: 48,
          normal: 98,
        ),
      ),
      variants: CardVariant(
        firstEdition: false,
        holo: true,
        reverse: false,
        promo: false,
        normal: false,
      ),
      item: null,
    );

    expect(card.id, "xy7-54");
    expect(card.localId, "54");
    expect(card.name, "Gardevoir EX");
    expect(card.image, "https://images.pokemontcg.io/xy7/54.png");
    expect(card.category, CardCategory.pokemon);
    expect(card.illustrator, "5ban Graphics");
    expect(card.rarity, "Rare Holo EX");
    expect(card.setBrief.name, "Ancient Origins");
    expect(card.setBrief.id, "xy7");
    expect(card.setBrief.logoUrl, "https://example.com/logo.png");
    expect(card.setBrief.symbolUrl, "https://example.com/symbol.png");
    expect(card.setBrief.cardCount.total, 98);
    expect(card.setBrief.cardCount.official, 98);
    expect(card.setBrief.cardCount.firstEd, null);
    expect(card.setBrief.cardCount.holo, 50);
    expect(card.setBrief.cardCount.reverse, 48);
    expect(card.setBrief.cardCount.normal, 98);
    expect(card.variants.firstEdition, false);
    expect(card.variants.holo, true);
    expect(card.variants.reverse, false);
    expect(card.variants.promo, false);
    expect(card.variants.normal, false);
    expect(card.item, null);
  });
}
