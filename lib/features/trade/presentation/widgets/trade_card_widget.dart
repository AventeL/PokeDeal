import 'package:flutter/material.dart';

class TradeCardRequestWidget extends StatelessWidget {
  final bool isNew;
  final bool isTradeSent;
  final VoidCallback? onTap;

  const TradeCardRequestWidget({
    super.key,
    this.isNew = false,
    this.isTradeSent = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = BorderRadius.circular(12);

    return Material(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Container(
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
                      'Cocorico',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      isTradeSent
                          ? 'Propose d’échanger une carte'
                          : 'Vous propose un échange',
                    ),
                  ],
                ),
                Spacer(),
                if (isNew) Icon(Icons.circle, color: Colors.orange, size: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
