import 'package:flutter/material.dart';
import 'package:pokedeal/features/trade/domain/models/trade.dart';

class TradeCardRequestWidget extends StatelessWidget {
  final bool isNew;
  final VoidCallback? onTap;
  final Trade trade;
  final isTradeReceived;

  const TradeCardRequestWidget({
    super.key,
    this.isNew = false,
    this.onTap,
    required this.trade,
    required this.isTradeReceived,
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = BorderRadius.circular(12);

   return Material(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      borderRadius: borderRadius,
  child: InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: borderRadius,
        ),
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.person),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isTradeReceived
                        ? trade.sender_id.pseudo
                        : trade.receive_id.pseudo,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    isTradeReceived
                        ? 'Vous propose un échange'
                        : "A reçu votre demande d'échange",
                  ),
                ],
              ),
              Spacer(),
              if (isNew) Icon(Icons.circle, color: Colors.orange, size: 10),
            ],),
          ),
        ),
      ),
    );
  }
}
