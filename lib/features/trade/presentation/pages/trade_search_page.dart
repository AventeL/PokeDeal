import 'package:flutter/material.dart';
import 'package:pokedeal/core/widgets/empty_space.dart';
import 'package:pokedeal/features/trade/presentation/widgets/trade_profile_card_widget.dart';

class TradeSearchPage extends StatelessWidget {
  const TradeSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Rechercher un collectionneur',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          4.height,
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: TradeProfileCardWidget(onTap: onProfileTap),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void onProfileTap() {}
}
