import 'package:flutter/material.dart';

import '../../domain/models/card/base_pokemon_card.dart';
import '../../domain/models/enum/variant_value.dart';

class SheetDeleteCardToCollection extends StatefulWidget {
  final BasePokemonCard card;
  final VariantValue variant;
  final void Function(int quantity, VariantValue variant) onConfirm;

  const SheetDeleteCardToCollection({
    super.key,
    required this.card,
    required this.variant,
    required this.onConfirm,
  });

  @override
  State<SheetDeleteCardToCollection> createState() =>
      _SheetDeleteCardToCollectionState();
}

class _SheetDeleteCardToCollectionState
    extends State<SheetDeleteCardToCollection> {
  late final TextEditingController _quantityController;
  late VariantValue _selectedVariant;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: '1');
    _selectedVariant = widget.variant;
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
              'Voulez-vous supprimer ${widget.card.name} de votre collection ?',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantité',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<VariantValue>(
                  value: _selectedVariant,
                  items:
                      VariantValue.values.map((variant) {
                        return DropdownMenuItem<VariantValue>(
                          value: variant,
                          child: Text(variant.getFullName),
                        );
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedVariant = value;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final quantity = int.tryParse(_quantityController.text);
                if (quantity != null && quantity > 0) {
                  widget.onConfirm(quantity, _selectedVariant);
                  Navigator.pop(context);
                }
              },
              child: const Text('Confirmer'),
            ),
          ],
        ),
      ),
    );
  }
}
