import 'package:flutter/material.dart';
import 'package:pokedeal/core/helper/pokemon_card_helper.dart';
import 'package:pokedeal/core/widgets/empty_space.dart';
import 'package:pokedeal/features/collection/domain/models/card/base_pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';
import 'package:pokedeal/shared/widgets/custom_large_button.dart';

class BottomSheetAddCardToCollection extends StatefulWidget {
  final BasePokemonCard card;
  final void Function(int quantity, VariantValue variant) onConfirm;

  const BottomSheetAddCardToCollection({
    super.key,
    required this.card,
    required this.onConfirm,
  });

  @override
  State<BottomSheetAddCardToCollection> createState() =>
      _BottomSheetAddCardToCollectionState();
}

class _BottomSheetAddCardToCollectionState
    extends State<BottomSheetAddCardToCollection> {
  late final TextEditingController _quantityController;
  VariantValue _selectedVariant = VariantValue.normal;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: '1');
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Voulez-vous ajouter ${widget.card.name} à votre collection ?',
              textAlign: TextAlign.center,
            ),
            16.height,
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Quantité',
                    ),
                  ),
                ),
                16.width,
                Expanded(
                  child: DropdownButtonFormField<VariantValue>(
                    value: _selectedVariant,
                    items:
                        PokemonCardHelper.getVariants(widget.card)
                            .map(
                              (rarity) => DropdownMenuItem(
                                value: rarity,
                                child: Text(rarity.getFullName),
                              ),
                            )
                            .toList(),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Rareté',
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedVariant = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            16.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Annuler',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                8.width,
                Expanded(
                  child: CustomLargeButton(
                    label: 'Ajouter',
                    onPressed: () {
                      final quantity =
                          int.tryParse(_quantityController.text) ?? 1;
                      widget.onConfirm(quantity, _selectedVariant);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
