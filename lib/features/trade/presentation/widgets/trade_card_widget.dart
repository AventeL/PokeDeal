import 'package:flutter/material.dart';
import 'package:pokedeal/features/trade/domain/models/enum/trade_status.dart';
import 'package:pokedeal/features/trade/domain/models/trade.dart';

class TradeCardRequestWidget extends StatelessWidget {
  final bool isNew;
  final VoidCallback? onTap;
  final Trade trade;
  final bool isTradeReceived;

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
        borderRadius: borderRadius,
        child: Container(
          decoration: BoxDecoration(borderRadius: borderRadius),
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
                          ? trade.senderId.pseudo
                          : trade.receiveId.pseudo,
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
                buildStatusIcon(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildStatusIcon() {
    if (trade.status == TradeStatus.waiting) {
      return Icon(Icons.pending, color: Colors.orange);
    } else if (trade.status == TradeStatus.accepted) {
      return Icon(Icons.check_circle, color: Colors.green);
    } else if (trade.status == TradeStatus.refused) {
      return Icon(Icons.cancel, color: Colors.red);
    }
    return SizedBox.shrink();
  }
}
