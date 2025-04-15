import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/collection/domain/models/card/user_card_collection.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';

void main() {
  test('UserCardCollection has a constructor', () {
    const userCardCollection = UserCardCollection(
      id: '1',
      userId: 'user1',
      quantity: 10,
      cardId: 'card1',
      variant: VariantValue.holo,
      setId: 'set1',
    );

    expect(userCardCollection.id, '1');
    expect(userCardCollection.userId, 'user1');
    expect(userCardCollection.quantity, 10);
    expect(userCardCollection.cardId, 'card1');
    expect(userCardCollection.variant, VariantValue.holo);
    expect(userCardCollection.setId, 'set1');
  });

  test('UserCardCollection has a fromJson method', () {
    final json = {
      'id': '1',
      'user_id': 'user1',
      'quantity': 10,
      'card_id': 'card1',
      'variant': 'Holo',
      'set_id': 'set1',
    };

    final userCardCollection = UserCardCollection.fromJson(json);

    expect(userCardCollection.id, '1');
    expect(userCardCollection.userId, 'user1');
    expect(userCardCollection.quantity, 10);
    expect(userCardCollection.cardId, 'card1');
    expect(userCardCollection.variant, VariantValue.holo);
    expect(userCardCollection.setId, 'set1');
  });

  test('UserCardCollection equals operator works correctly', () {
    const collection1 = UserCardCollection(
      id: '1',
      userId: 'user1',
      quantity: 10,
      cardId: 'card1',
      variant: VariantValue.holo,
      setId: 'set1',
    );

    const collection2 = UserCardCollection(
      id: '1',
      userId: 'user1',
      quantity: 10,
      cardId: 'card1',
      variant: VariantValue.holo,
      setId: 'set1',
    );

    const collection3 = UserCardCollection(
      id: '2',
      userId: 'user2',
      quantity: 5,
      cardId: 'card2',
      variant: VariantValue.reverse,
      setId: 'set2',
    );

    expect(collection1 == collection2, true);
    expect(collection1 == collection3, false);
  });
}
