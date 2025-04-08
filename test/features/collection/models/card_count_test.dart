import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/collection/domain/models/card_count.dart';

void main() {
  test('CardCount has a constructor', () {
    final cardCount = CardCount(
      total: 100,
      official: 50,
      holo: 30,
      firstEd: 20,
      reverse: 10,
      normal: 5,
    );

    expect(cardCount.total, 100);
    expect(cardCount.official, 50);
    expect(cardCount.holo, 30);
    expect(cardCount.firstEd, 20);
    expect(cardCount.reverse, 10);
    expect(cardCount.normal, 5);
  });

  test('CardCount has a fromJson', () {
    final json = {'total': 100, 'official': 50};

    final cardCount = CardCount.fromJson(json);

    expect(cardCount.total, 100);
    expect(cardCount.official, 50);
    expect(cardCount.holo, null);
    expect(cardCount.firstEd, null);
    expect(cardCount.reverse, null);
    expect(cardCount.normal, null);
  });
}
