import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/collection/domain/models/legal.dart';

void main() {
  test('Legal has a constructor', () {
    final legal = Legal(expanded: true, standard: false);

    expect(legal.expanded, true);
    expect(legal.standard, false);
  });

  test('Legal has a fromJson', () {
    final json = {'expanded': true, 'standard': false};

    final legal = Legal.fromJson(json);

    expect(legal.expanded, true);
    expect(legal.standard, false);
  });
}
