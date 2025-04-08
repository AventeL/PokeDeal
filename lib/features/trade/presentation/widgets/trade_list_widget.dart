import 'package:flutter/material.dart';
import 'package:pokedeal/features/trade/presentation/widgets/trade_card_widget.dart';

class TradeListWidget extends StatelessWidget {
  const TradeListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildTradeList();
  }

  Widget _buildTradeList() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TradeCardRequestWidget(onTap: onTradeCardWidgetTap),
          );
        },
      ),
    );
  }

  void onTradeCardWidgetTap() {
    //@todo
  }
}
