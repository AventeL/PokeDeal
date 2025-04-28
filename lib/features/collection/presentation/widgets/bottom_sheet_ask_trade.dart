import 'package:flutter/material.dart';
import 'package:pokedeal/core/widgets/empty_space.dart';
import 'package:pokedeal/features/collection/domain/models/card/base_pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';
import 'package:pokedeal/shared/widgets/custom_large_button.dart';

class BottomSheetAskTrade extends StatefulWidget {
  final BasePokemonCard card;
  final void Function(VariantValue variant) onConfirm;
  final List<VariantValue> availableVariants;

  const BottomSheetAskTrade({
    super.key,
    required this.onConfirm,
    required this.card,
    required this.availableVariants,
  });

  @override
  State<BottomSheetAskTrade> createState() => _BottomSheetAskTradeState();
}

class _BottomSheetAskTradeState extends State<BottomSheetAskTrade> {
  late VariantValue _selectedVariant;

  @override
  void initState() {
    super.initState();
    _selectedVariant =
        widget.availableVariants.contains(VariantValue.normal)
            ? VariantValue.normal
            : widget.availableVariants.first;
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
              'Voulez-vous demander un échange pour cette carte ?',
              textAlign: TextAlign.center,
            ),
            16.height,
            DropdownButtonFormField<VariantValue>(
              value: _selectedVariant,
              items:
                  widget.availableVariants
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
                    label: 'Demander',
                    onPressed: () {
                      widget.onConfirm(_selectedVariant);
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
